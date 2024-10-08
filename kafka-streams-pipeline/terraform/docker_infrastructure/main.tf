terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"  # The version you're using in your root module
    }
    kafka = {
      source  = "mongey/kafka"
      version = "0.7.1"  # The Kafka provider
    }
  }
}

# Docker provider configuration
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Kafka provider configuration
provider "kafka" {
  bootstrap_servers = ["localhost:9092"]
}
