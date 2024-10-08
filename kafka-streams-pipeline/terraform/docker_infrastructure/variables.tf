# Declare the variables used by the docker_infrastructure module
variable "stream_processor_image_name" {
  description = "The name of the Docker image for the Kafka stream processor."
  type        = string
}

variable "dockerhub_username" {
  description = "DockerHub username for pushing/pulling images."
  type        = string
}

variable "kafka_topics" {
  type        = list(string)
  description = "List of Kafka topics to be created"
  default     = ["input_topic", "output_topic"]
}


