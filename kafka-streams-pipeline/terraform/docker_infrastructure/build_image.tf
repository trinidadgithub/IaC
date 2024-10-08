
resource "docker_image" "stream_processor_image" {
  name          = "${var.dockerhub_username}/${var.stream_processor_image_name}:latest"
  build {
    context    = "${path.root}/.."
    dockerfile = "${path.root}/../Dockerfile"
  }

# Place holder for docker push
#    provisioner "local-exec" {
#    command = "docker push ${var.dockerhub_username}/stream-processor:latest"

}

resource "docker_image" "custom_kafka_with_nc" {
  name         = "custom-kafka-with-nc"
  build {
    context = "${path.module}/docker_infrastructure"
    dockerfile = "${path.module}/Dockerfile"
  }
}

#resource "docker_registry_image" "stream_processor_image" {
#  name = "${var.dockerhub_username}/${docker_image.stream_processor_image.name}"
#}


