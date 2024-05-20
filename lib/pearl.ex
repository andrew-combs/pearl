defmodule Pearl do
  @moduledoc """
  Pearl keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  require Logger
  require OpenTelemetry.Tracer, as: Tracer

  def user_input(string) do
    Tracer.with_span "user_input" do
      Logger.info("User wrote: #{string}")
      :ok
    end
  end
end
