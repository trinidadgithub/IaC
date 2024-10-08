# Declare the variables used by the docker_infrastructure module
variable "kafka_topics" {
  description = "List of Kafka topics to be created"
  type        = list(string)
  default     = ["input_topic", "output_topic"]  # Example default values
}

variable "dockerhub_username" {
  description = "DockerHub username for pushing/pulling images"
  type        = string
}

variable "stream_processor_image_name" {
  description = "The name of the Docker image for the stream processor"
  type        = string
  default     = "stream-processor"
}

