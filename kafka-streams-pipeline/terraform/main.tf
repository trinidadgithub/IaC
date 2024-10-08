terraform {
  required_providers {
    kafka = {
      source  = "mongey/kafka"
      version = "0.7.1"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

provider "kafka" {
  bootstrap_servers = ["localhost:9092"]
}

module "docker_infrastructure" {
  source = "./docker_infrastructure"

  stream_processor_image_name = var.stream_processor_image_name
  dockerhub_username          = var.dockerhub_username
  kafka_topics                = var.kafka_topics

}

