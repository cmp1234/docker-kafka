FROM openjdk:8u92-jre-alpine
MAINTAINER King Chung Huang <kchuang@ucalgary.ca>

ENV KAFKA_VERSION=0.10.0.1 \
    SCALA_VERSION=2.11 \
    GPG_KEY=AB55EF5C \
    KAFKA_HOME=/kafka

# Install required packages
RUN apk add --no-cache \
		bash

# Download and install Kafka
RUN log () { echo -e "\033[01;95m$@\033[0m"; } && \

	apk add --no-cache --virtual .build-deps \
		gnupg \
		tar && \

	INSTALL_DIR="$(mktemp -d)" && \
	export GNUPGHOME="$(mktemp -d)" && \

	log "Download kafka archive and signature file" && \
	wget -O "$INSTALL_DIR/kafka.tgz" "http://www.apache.org/dist/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz" && \
	wget -O "$INSTALL_DIR/kafka.tgz.asc" "http://www.apache.org/dist/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz.asc" && \

	log "Check the kafka archive signature" && \
	# See http://www.apache.org/info/verification.html and http://kafka.apache.org/KEYS

	gpg --keyserver ha.pool.sks-keyservers.net --recv-key $GPG_KEY && \
	gpg --batch --verify "$INSTALL_DIR/kafka.tgz.asc" "$INSTALL_DIR/kafka.tgz" && \

	log "Unpack kafka" && \
	mkdir $KAFKA_HOME && \
	tar -xz --directory="$KAFKA_HOME" --strip-components=1 --file="$INSTALL_DIR/kafka.tgz" && \

	log "Remove Windows files" && \
	rm -r "$KAFKA_HOME/bin/windows" && \

	log "Clean up" && \
	rm -r "$INSTALL_DIR" "$GNUPGHOME" && \
	apk del .build-deps

WORKDIR $KAFKA_HOME

ENV PATH=$PATH:$KAFKA_HOME/bin

EXPOSE 9092

CMD ["kafka-server-start.sh", "/kafka/config/server.properties"]
