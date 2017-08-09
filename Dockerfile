FROM cmp1234/jre-su-exec:security-latest-alpine3.6

ENV KAFKA_VERSION=0.10.1.1 \
    SCALA_VERSION=2.12 \
    GPG_KEY=AB55EF5C \
    KAFKA_HOME=/kafka

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
	wget -O "$INSTALL_DIR/KEYS" "http://kafka.apache.org/KEYS" && \
	gpg --import "$INSTALL_DIR/KEYS" && \
	gpg --batch --verify "$INSTALL_DIR/kafka.tgz.asc" "$INSTALL_DIR/kafka.tgz" && \

	log "Unpack kafka" && \
	mkdir $KAFKA_HOME && \
	tar -xz --directory="$KAFKA_HOME" --strip-components=1 --file="$INSTALL_DIR/kafka.tgz" && \

	log "Remove Windows files" && \
	rm -r "$KAFKA_HOME/bin/windows" && \

	log "Clean up" && \
	apk del .build-deps && \
	rm -r "$INSTALL_DIR" && \
	ls -l "$GNUPGHOME" && \
	log "finished"


# Adjust the default server properties to connect to Zookeeper at zookeeper:2181
ENV ZOOKEEPER_HOST=zookeeper \
    ZOOKEEPER_PORT=2181
RUN sed -i "s/zookeeper.connect=.*/zookeeper.connect=$ZOOKEEPER_HOST:$ZOOKEEPER_PORT/g" /kafka/config/server.properties

# Add wait-for-it script, for use in waiting for Zookeeper
ADD https://raw.githubusercontent.com/ucalgary/wait-for-it/master/wait-for-it.sh /usr/local/bin/wait-for-it
RUN chmod 755 /usr/local/bin/wait-for-it

WORKDIR $KAFKA_HOME

ENV PATH=$PATH:$KAFKA_HOME/bin

EXPOSE 9092

CMD wait-for-it -h $ZOOKEEPER_HOST -p $ZOOKEEPER_PORT -s -t 30 -- kafka-server-start.sh /kafka/config/server.properties

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="Apache Kafka" \
      org.label-schema.version="0.10.1.1" \
      org.label-schema.url="https://kafka.apache.org" \
      org.label-schema.vcs-url="https://github.com/ucalgary/docker-kafka"
