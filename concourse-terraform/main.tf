terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>2.23.0"
    }
  }
}

provider "docker" {
  #  For *nix
  #  host = "unix:///var/run/docker.sock"
  # For Windows
  host = "npipe:////./pipe/docker_engine"
}

# Create a Docker network for Concourse
resource "docker_network" "concourse_network" {
  name = "concourse-network"
}

# Create the backend Concourse database
resource "docker_container" "concourse_db" {
  name  = "concourse-db"
  image = "postgres:13"

  env = [
    "POSTGRES_DB=concourse",
    "POSTGRES_USER=concourse_user",
    "POSTGRES_PASSWORD=concourse_pass"
  ]

  networks_advanced {
    name = docker_network.concourse_network.name
  }

  ports {
    internal = 5432
    external = 5432
  }

  restart = "always"
}

# Web Container
resource "docker_container" "concourse_web" {
  name  = "concourse-web"
  image = "concourse/concourse"

  env = [
    "CONCOURSE_POSTGRES_HOST=${docker_container.concourse_db.name}",  # Use container name
    "CONCOURSE_POSTGRES_USER=concourse_user",
    "CONCOURSE_POSTGRES_PASSWORD=concourse_pass",
    "CONCOURSE_POSTGRES_DATABASE=concourse",
    "CONCOURSE_EXTERNAL_URL=http://localhost:8080",
    "CONCOURSE_ADD_LOCAL_USER=admin:admin",
    "CONCOURSE_MAIN_TEAM_LOCAL_USER=admin",
    "CONCOURSE_TSA_AUTHORIZED_KEYS=/concourse-public/authorized_worker_keys",
    "CONCOURSE_TSA_HOST_KEY=/concourse-keys/tsa_host_key"
  ]

  command = ["web"]

  volumes {
    host_path      = abspath("${path.module}/keys/authorized_worker_keys")
    container_path = "/concourse-public/authorized_worker_keys"
  }

    volumes {
    host_path      = abspath("${path.module}/keys/tsa_host_key")
    container_path = "/concourse-public/tsa_host_key"
  }

  ports {
    internal = 8080
    external = 8080
  }

  networks_advanced {
    name = docker_network.concourse_network.name
  }

  depends_on = [docker_container.concourse_db, data.external.worker_public_key_ssh]
}

# Worker Container
resource "docker_container" "concourse_worker" {
  name       = "concourse-worker"
  image      = "concourse/concourse"
  privileged = true

  env = [
    "CONCOURSE_WORKER_BAGGAGECLAIM_DRIVER=overlay",
    "CONCOURSE_RUNTIME=containerd",
    "CONCOURSE_TSA_HOST_KEY=/concourse-keys/tsa_host_key",
    "CONCOURSE_TSA_AUTHORIZED_KEYS=/concourse-keys/tsa_host_key.pub",
    "CONCOURSE_TSA_PUBLIC_KEY=/concourse-keys/tsa_host_key.pub",
    "CONCOURSE_WORKER_TSA_WORKER_PRIVATE_KEY=/concourse-keys/worker_key",
    "CONCOURSE_TSA_HOST=concourse-web:2222"
  ]

  command = [
    "worker",
    "--work-dir=/worker"
  ]

  volumes {
    host_path      = abspath("${path.module}/keys/worker_key")
    container_path = "/concourse-keys/worker_key"
  }

  networks_advanced {
    name = docker_network.concourse_network.name
  }

  depends_on = [docker_container.concourse_web]
}

# Store the worker's private key locally
# Add a two second sleep to ensure the file creation completes before provisioning
# Adjust sleep as needed.
resource "local_file" "worker_key" {
  content  = tls_private_key.worker_key.private_key_pem
  filename = abspath("${path.module}/keys/worker_key")

  provisioner "local-exec" {
    command = "powershell Start-Sleep -Seconds 2; powershell -File ${path.module}/scripts/set_permissions.ps1 -PrivateKeyPath '${path.module}/keys/worker_key'"
  }

  depends_on = [tls_private_key.worker_key]
}

# Generate the worker's public key in PEM format
resource "local_file" "worker_public_key" {
  content  = tls_private_key.worker_key.public_key_pem
  filename = abspath("${path.module}/keys/worker_key.pub")
}

# External data source to convert PEM private key to SSH public key format
data "external" "worker_public_key_ssh" {
  program = ["powershell", "./scripts/convert_to_ssh_format.ps1", abspath("${path.module}/keys/worker_key")]

  depends_on = [local_file.worker_key]  # Ensure worker_key is created first
}

# Use the converted SSH key for authorized_worker_keys
resource "local_file" "authorized_worker_keys" {
  content  = data.external.worker_public_key_ssh.result.ssh_key
  filename = abspath("${path.module}/keys/authorized_worker_keys")
}

resource "local_file" "session_signing_key" {
  content = tls_private_key.session_signing_key.private_key_pem
  filename = abspath("${path.module}/keys/session_signing_key")
}