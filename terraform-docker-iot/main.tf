terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>2.23.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "iot_image" {
  name = "my-iot-project:latest"
  build {
    path = "${path.module}"  # Specify the Docker build context
  }
}

resource "docker_container" "iot_container" {
  name  = "iot-project-container"
  image = docker_image.iot_image.name

  ports {
    internal = 8883
    external = 8883
  }

  # Use absolute paths for volume mounts
  volumes {
    host_path      = "${abspath("${path.module}/root-CA.crt")}"
    container_path = "/app/root-CA.crt"
  }

  volumes {
    host_path      = "${abspath("${path.module}/iot-thing.cert.pem")}"
    container_path = "/app/iot-thing.cert.pem"
  }

  volumes {
    host_path      = "${abspath("${path.module}/iot-thing-Policy")}"
    container_path = "/app/iot-thing-Policy"
  }

  restart = "always"
}

