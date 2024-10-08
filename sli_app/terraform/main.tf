terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.0.0"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "3.2.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Docker Network
resource "docker_network" "sli_network" {
  name = "sli_network"
}

# Flask Application Container
resource "docker_image" "flask_app_image" {
  name = "sli_app:latest"

  build {
    context = "../"
  }
}

resource "docker_container" "flask_app" {
  name  = "sli_app"
  image = docker_image.flask_app_image.name
  networks_advanced {
    name = docker_network.sli_network.name
  }

  ports {
    internal = 5000
    external = 5000
  }

  ports {
    internal = 8000
    external = 8000
  }
}

# Prometheus Container
resource "docker_image" "prometheus_image" {
  name = "prom/prometheus:latest"
}

resource "docker_container" "prometheus" {
  name  = "prometheus"
  image = docker_image.prometheus_image.name
  networks_advanced {
    name = docker_network.sli_network.name
  }

  ports {
    internal = 9090
    external = 9090
  }

  volumes {
    host_path      = abspath("${path.module}/prometheus.yml")
    container_path = "/etc/prometheus/prometheus.yml"
  }
}

# Grafana Container
resource "docker_image" "grafana_image" {
  name = "grafana/grafana:latest"
}

resource "docker_container" "grafana" {
  name  = "grafana"
  image = docker_image.grafana_image.name
  networks_advanced {
    name = docker_network.sli_network.name
  }

  ports {
    internal = 3000
    external = 3000
  }

  env = [
    "GF_SECURITY_ADMIN_PASSWORD=admin01"
  ]

  volumes {
    host_path      = abspath("${path.module}/grafana/provisioning")
    container_path = "/etc/grafana/provisioning"
  }

  provisioner "local-exec" {
  command = "sleep 30"
  }
}

# cAdvisor Container
resource "docker_image" "cadvisor_image" {
  name = "google/cadvisor:latest"
}

resource "docker_container" "cadvisor" {
  name  = "cadvisor"
  image = docker_image.cadvisor_image.name
  networks_advanced {
    name = docker_network.sli_network.name
  }

  ports {
    internal = 8080
    external = 8080
  }

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  volumes {
    host_path      = "/sys"
    container_path = "/sys"
    read_only      = true
  }

  volumes {
    host_path      = "/var/lib/docker/"
    container_path = "/var/lib/docker/"
    read_only      = true
  }
}

# Grafana Provider Configuration
provider "grafana" {
  url  = "http://localhost:3000"
  auth = "admin:admin01"
}

# Grafana Service Account and Token
resource "grafana_service_account" "my_service_account" {
  name = "my-automation-sa"
  role = "Admin"
  depends_on = [docker_container.grafana]
}

resource "grafana_service_account_token" "my_sa_token" {
  service_account_id = grafana_service_account.my_service_account.id
  name               = "my-sa-api-token"
}

data "grafana_data_source" "prometheus" {
  name = "Prometheus"

  depends_on = [ docker_container.grafana]
}

resource "grafana_folder" "infrastructure_monitoring" {
  title = "Infrastructure Monitoring"

  depends_on = [docker_container.grafana]
}

data "template_file" "dashboard_json" {
  template = file("${path.module}/grafana/dashboards/system-docker-monitoring.json")
  vars = {
    prometheus_uid = data.grafana_data_source.prometheus.uid
  }
}

resource "grafana_dashboard" "docker_insights_dashboard" {
  config_json = data.template_file.dashboard_json.rendered
  folder      = grafana_folder.infrastructure_monitoring.id # Use folder ID
  overwrite   = true
}


