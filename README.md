# Kafka

[![](https://images.microbadger.com/badges/image/ucalgary/kafka.svg)](https://microbadger.com/images/ucalgary/kafka) [![Anchore Image Overview](https://anchore.io/service/badges/image/1833f7b5abc397663b33d995377780431d46fa88c0474a3dc6d29aa21ec49cc0)](https://anchore.io/image/dockerhub/ucalgary%2Fkafka%3Alatest)

[Kafka](https://kafka.apache.org) is a distributed streaming platform that lets you publish and subscribe to streams of records in fault-tolerant way and lets you process streams of records as they occur.

## Starting a Kafka Broker

Kafka is a distributed system that uses Zookeeper to coordinate Kafka brokers and keep track of Kafka topics and partitions. Before starting Kafka, you need a Zookeeper service that it can connect to. The [official zookeeper image](https://hub.docker.com/_/zookeeper/) can be used to create and start a Zookeeper container.

```
docker run --name zookeeper -d zookeeper
```

Next, create and start a Kafka container, with a link to the Zookeeper container. This Kafka image is pre-configured to connect to Zookeeper using the service name `zookeeper` on port `2181`, the default Zookeeper client port.

```
docker run --name kakfa --link zookeeper:zookeeper -d ucalgary/kafka
```

## Defining a Simple Kafka Stack

[Docker Compose files](https://docs.docker.com/compose/compose-file/) can be used to define and run multi-container systems. Since Kafka requires Zookeeper to run, a Compose file is a great way to define the two services and deploy them together.

Here is a simple Compose file that defines services for Zookeeper and Kafka.

```
version: '3'
services:
  zookeeper:
    image: zookeeper
  kafka:
    image: ucalgary/kafka
    depends_on:
    - zookeeper
```

Both services will be connected to a default network for this stack when it is brought up using Docker Compose or deployed as a [stack in swarm mode](https://docs.docker.com/engine/reference/commandline/stack_deploy/). Containers for the `kafka` service can automatically connect to `zookeeper` containers via the service name.

The [`depends_on`](https://docs.docker.com/compose/compose-file/#/dependson) parameter expresses a dependency from the kafka service to the zookeeper service. If you specifically tell Docker Compose to start the `kafka` service, Docker Compose will also start the `zookeeper` service because of the declared dependency.

*Note: `depends_on` does not apply for Docker stack deployments.*

## Maintenance

This image is currently maintained by the Research Management Systems project at the [University of Calgary](http://www.ucalgary.ca/).
