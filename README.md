# Kafka

[![](https://images.microbadger.com/badges/image/ucalgary/kafka.svg)](https://microbadger.com/images/ucalgary/kafka)

[Kafka](https://kafka.apache.org) is a distributed streaming platform that lets you publish and subscribe to streams of records in fault-tolerant way and lets you process streams of records as they occur.

## Starting a Kafka Broker

Kafka is a distributed system that uses Zookeeper for coordination and state management. Before starting Kafka, you need a Zookeeper service that it can connect to. The [official zookeeper image](https://hub.docker.com/_/zookeeper/) can be used to create and start a Zookeeper container.

```
docker run --name zookeeper -d zookeeper
```

Next, create and start a Kafka container, with a link to the Zookeeper container. This Kafka image is pre-configured to connect to Zookeeper using the service name `zookeeper` on port `2181`, the default Zookeeper client port.

```
docker run --name kakfa --link zookeeper:zookeeper -d ucalgary/kafka
```

## Maintenance

This image is currently maintained by the Research Management Systems project at the [University of Calgary](http://www.ucalgary.ca/).
