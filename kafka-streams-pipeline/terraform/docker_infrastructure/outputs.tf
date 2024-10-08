output "stream_processor_image_id" {
  value = docker_image.stream_processor_image.image_id
  description = "The ID of the Docker image for the stream processor."
}

# Output Kafka broker URL
output "kafka_broker_url" {
  value       = "localhost:9092"
  description = "The URL of the Kafka broker"
}

# Output Docker Hub URL for the stream processor image
output "stream_processor_image_url" {
  value       = "https://hub.docker.com/r/${var.dockerhub_username}/stream-processor"
  description = "The Docker Hub URL for the stream processor image"
}

# Add other critical URLs as necessary, like web applications
output "web_app_url" {
  value       = "http://localhost:8080"
  description = "The URL of the deployed web application"
}
