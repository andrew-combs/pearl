# Pearl

`Pearl` is a sample application meant for testing an easy configuration for locally running
an ELK-enabled Phoenix application

## Getting Started

To start all services, simply run `docker-compose up`. Add `-d` to detach the services on startup
so you can stil use the terminal.

## Getting Started with Kibana

> For information on the elasticsearch/kibana sevice configuration in the
> docker-compose.yml file, please refer to the following reference:
>
> https://discuss.elastic.co/t/set-password-and-user-with-docker-compose/225075/2

Kibana and Elasticsearch will take a few moments to start up. After they have finished
initializing, Kibana can be opened by navigating to `localhost:5601`. You should see
the landing page for Kibana.

At this point, nothing is configured.
