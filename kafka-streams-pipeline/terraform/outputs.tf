output "kafka_bootstrap_servers" {
  description = "Kafka Bootstrap Servers"
  value       = "localhost:9092"
}

output "stream_processor_image_id" {
  value       = module.docker_infrastructure.stream_processor_image_id
  description = "The ID of the Docker image for the stream processor."
}
