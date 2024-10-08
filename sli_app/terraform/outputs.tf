output "flask_app_url" {
  description = "the URL to access flask application"
  value = "http://localhost:${var.flask_port}"
}

output "prometheus_url" {
  description = "The URL to access prometheus"
  value = "http://localhost:${var.prometheus_port}"
}

output "grafana_url" {
  description = "The URL to access grafana"
  value = "http://localhost:${var.grafana_port}"
}

output "cadvisor_url" {
  description = "The URL to access cAdvisor"
  value       = "http://localhost:8080"
}
