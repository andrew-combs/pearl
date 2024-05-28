# Pearl

`Pearl` is a simple baseline application that can be used as a template or a reference for setting up
a Phoenix application with RabbitMQ, Broadway, OpenTelemetry, and monitoring (via prometheus
and grafana), more or less out of the box.

## Getting Started

To start all services, simply run `docker-compose up`. Add `-d` to detach the services on startup
so you can stil use the terminal.

Note that the application _should not_ be started until the compose services are up and running.
