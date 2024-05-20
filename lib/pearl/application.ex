defmodule Pearl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require OpenTelemetry.Tracer, as: Tracer
  require Logger

  @impl true
  def start(_type, _args) do
    :ok = start_otel()

    children = [
      PearlWeb.Telemetry,
      Pearl.Repo,
      {DNSCluster, query: Application.get_env(:pearl, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Pearl.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Pearl.Finch},
      # Start a worker by calling: Pearl.Worker.start_link(arg)
      # {Pearl.Worker, arg},
      # Start to serve requests, typically the last entry
      PearlWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pearl.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def start_phase(:declare_rabbit_queues, _phase_type, config) do
    Tracer.with_span "application.start_phase.declare_rabbit_queues" do
      endpoint = Keyword.get(config, :endpoint, "localhost")
      port = Keyword.get(config, :port, 5672)
      username = Keyword.get(config, :username, "pearljam")
      password = Keyword.get(config, :password, "pearljam")
      queues = Keyword.fetch!(config, :queues)

      {:ok, connection} =
        AMQP.Connection.open(
          endpoint: endpoint,
          port: port,
          username: username,
          password: password
        )

      {:ok, channel} = AMQP.Channel.open(connection)

      queues_created =
        Enum.reduce(queues, 0, fn queue, count ->
          AMQP.Queue.declare(channel, queue)
          count + 1
        end)

      AMQP.Connection.close(connection)
      Tracer.set_attribute("queues_created", queues_created)

      :ok
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PearlWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp start_otel do
    :opentelemetry_cowboy.setup()
    OpentelemetryPhoenix.setup(adapter: :cowboy2)
  end
end
