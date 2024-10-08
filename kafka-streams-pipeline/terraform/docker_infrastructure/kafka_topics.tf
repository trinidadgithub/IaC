# Create Kafka Topic
resource "null_resource" "create_kafka_topic-1" {
  provisioner "local-exec" {
    command = <<EOT
      /opt/kafka/bin/kafka-topics.sh --create --topic test-input-topic-1 \
      --bootstrap-server localhost:9092 \
      --partitions 1 \
      --replication-factor 1 \
      --config cleanup.policy=delete \
      --config compression.type=gzip \
      --config delete.retention.ms=86400000 \
      --config min.cleanable.dirty.ratio=0.01
    EOT
  }

  depends_on = [null_resource.wait_for_kafka]
}

resource "null_resource" "create_kafka_topic-2" {
  provisioner "local-exec" {
    command = <<EOT
      /opt/kafka/bin/kafka-topics.sh --create --topic test-input-topic-2 \
      --bootstrap-server localhost:9092 \
      --partitions 1 \
      --replication-factor 1 \
      --config cleanup.policy=delete \
      --config compression.type=gzip \
      --config delete.retention.ms=86400000 \
      --config min.cleanable.dirty.ratio=0.01
    EOT
  }

  depends_on = [null_resource.wait_for_kafka]
}
