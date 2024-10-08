output "helm_release_name" {
  description = "The Helm release name"
  value       = helm_release.myapp.name
}
