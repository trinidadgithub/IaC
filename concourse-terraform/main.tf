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

# Create a Docker network for Concourse
resource "docker_network" "concourse_network" {
  name = "concourse-network"
}

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

resource "docker_container" "concourse_web" {
  name  = "concourse-web"
  image = "concourse/concourse"

  env = [
    "CONCOURSE_POSTGRES_HOST=${docker_container.concourse_db.name}",
    "CONCOURSE_POSTGRES_USER=concourse_user",
    "CONCOURSE_POSTGRES_PASSWORD=concourse_pass",
    "CONCOURSE_POSTGRES_DATABASE=concourse",
    "CONCOURSE_EXTERNAL_URL=http://localhost:8080",
    "CONCOURSE_ADD_LOCAL_USER=admin:admin"
  ]

  command = ["web"]

  volumes = [
    "${abspath("${path.module}/keys/tsa_host_key")}:/concourse-keys/tsa_host_key",
    "${abspath("${path.module}/keys/tsa_host_key.pub")}:/concourse-keys/tsa_host_key.pub",
    "${abspath("${path.module}/keys/session_signing_key")}:/concourse-keys/session_signing_key"
  ]

  ports {
    internal = 8080
    external = 8080
  }

  networks_advanced {
    name = docker_network.concourse_network.name
  }

  depends_on = [docker_container.concourse_db]

  restart = "always"
}

resource "docker_container" "concourse_worker" {
  name  = "concourse-worker"
  image = "concourse/concourse"

  env = [
    "CONCOURSE_WORKER_BAGGAGECLAIM_DRIVER=overlay"
  ]

  command = [
    "worker",
    "--work-dir=/worker",
    "--tsa-host=concourse-web:2222",
    "--tsa-worker-private-key=/concourse-keys/worker_key"
  ]

  volumes = [
    "${abspath("${path.module}/keys/worker_key")}:/concourse-keys/worker_key"
  ]

  networks_advanced {
    name = docker_network.concourse_network.name
  }

  depends_on = [docker_container.concourse_web]

  restart = "always"
}

resource "local_file" "tsa_host_key" {
  content  = tls_private_key.tsa_host_key.private_key_pem
  filename = abspath("${path.module}/keys/tsa_host_key")
}

resource "local_file" "tsa_host_public_key" {
  content  = tls_private_key.tsa_host_key.public_key_pem
  filename = abspath("${path.module}/keys/tsa_host_key.pub")
}

resource "local_file" "worker_key" {
  content  = tls_private_key.worker_key.private_key_pem
  filename = abspath("${path.module}/keys/worker_key")
}

resource "local_file" "worker_public_key" {
  content  = tls_private_key.worker_key.public_key_pem
  filename = abspath("${path.module}/keys/worker_key.pub")
}

resource "local_file" "session_signing_key" {
  content  = tls_private_key.session_signing_key.private_key_pem
  filename = abspath("${path.module}/keys/session_signing_key")
}

