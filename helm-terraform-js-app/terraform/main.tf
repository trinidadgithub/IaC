resource "helm_release" "myapp" {
  name       = "myapp"
  chart      = "../helm/myapp"
  namespace  = "default"

  set {
    name  = "image.repository"
    value = var.docker_image_repository
  }

  set {
    name  = "image.tag"
    value = "latest"
  }
}
