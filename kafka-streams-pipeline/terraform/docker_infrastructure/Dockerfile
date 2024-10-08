FROM confluentinc/cp-kafka:latest
USER root
# Install netcat using yum (for Red Hat-based systems)
RUN yum -y update && yum -y install nc
RUN sed -i '/zookeeper/d' /etc/kafka/server.properties

USER appuser
# Ensure the Kafka container runs as expected
CMD ["/etc/confluent/docker/run"]
