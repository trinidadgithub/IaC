variable "aws_region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "docker_image_repository" {
  description = "Docker image repository for the application"
  default     = "your-dockerhub-username/myapp"
}
