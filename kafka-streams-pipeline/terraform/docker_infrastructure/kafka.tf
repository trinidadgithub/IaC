resource "docker_network" "kafka_network" {
  name   = "kafka_network"
  driver = "bridge"

  ipam_config {
    subnet = "172.19.0.0/24"  # Custom subnet
  }
}

resource "docker_container" "kafka_kraft" {
  name  = "kafka_kraft"
  image = docker_image.custom_kafka_with_nc.image_id

  env = [
    "KAFKA_KRAFT_MODE=true",
    "KAFKA_BROKER_ID=1",
    "KAFKA_PROCESS_ROLES=broker,controller",
    "KAFKA_NODE_ID=1",
    "KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093",
    "KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://localhost:9092",
    "KAFKA_CONTROLLER_QUORUM_VOTERS=1@localhost:9093",
    "KAFKA_LOG_DIRS=/var/lib/kafka/data",
    "KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=PLAINTEXT:PLAINTEXT,CONTROLLER:PLAINTEXT",
    "KAFKA_AUTO_CREATE_TOPICS_ENABLE=false",
    "KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1",
    "KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1",
    "KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1",
    "KAFKA_INTER_BROKER_LISTENER_NAME=PLAINTEXT",
    "KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER",
    "KAFKA_LOG_RETENTION_HOURS=10",
    "KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0",
    "CLUSTER_ID=4oc5a6d7-b8d9-4fb0-b4c6-7f2b8465d8f1"
  ]

  # Assign a static IP within the custom network
  networks_advanced {
    name    = docker_network.kafka_network.name
    ipv4_address = "172.19.0.2"  # Custom static IP
  }

  ports {
    internal = 9092
    external = 9092
  }

  ports {
    internal = 9093
    external = 9093
  }

  volumes {
    host_path      = abspath("${path.module}/data")
    container_path = "/var/lib/kafka/data"
    read_only      = false
  }
}

# Null resource to wait for Kafka to be ready on port 9092
resource "null_resource" "wait_for_kafka" {
  provisioner "local-exec" {
    command = <<EOT
      while ! nc -zv localhost 9092; do
        echo "Waiting for Kafka to start..."
        sleep 5
      done
     echo "Kafka is up!"
    EOT
  }
  depends_on = [docker_container.kafka_kraft]
}
