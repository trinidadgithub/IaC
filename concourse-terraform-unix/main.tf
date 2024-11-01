terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>2.23.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~>3.0"
    }
  }
}

# Configure Vault provider
provider "vault" {
  address = "http://127.0.0.1:8200"  # Replace with your Vault server address
  token   = var.vault_token  # Use environment variable or Vault CLI for security
}

# Retrieve PostgreSQL password from Vault
data "vault_generic_secret" "concourse_db_password" {
  path = "secret/concourse-db"
}

# Retrieve Concourse user credentials from Vault
data "vault_generic_secret" "concourse_user_config" {
  path = "secret/concourse-config"
}

# Retrieve key files from vault
data "vault_generic_secret" "authorized_worker_keys" {
  path = "secret/concourse/authorized_worker_keys"
}

data "vault_generic_secret" "session_signing_key" {
  path = "secret/concourse/session_signing_key"
}

data "vault_generic_secret" "tsa_host_key" {
  path = "secret/concourse/tsa_host_key"
}

data "vault_generic_secret" "tsa_host_key_pub" {
  path = "secret/concourse/tsa_host_key_pub"
}

data "vault_generic_secret" "worker_key" {
  path = "secret/concourse/worker_key"
}

data "vault_generic_secret" "worker_key_pub" {
  path = "secret/concourse/worker_key_pub"
}

# Create local files from the retrieved keys
resource "local_file" "authorized_worker_keys" {
  content  = data.vault_generic_secret.authorized_worker_keys.data["value"]
  filename = abspath("${path.module}/keys/authorized_worker_keys")
}

resource "local_file" "session_signing_key" {
  content  = data.vault_generic_secret.session_signing_key.data["value"]
  filename = abspath("${path.module}/keys/session_signing_key")
}

resource "local_file" "tsa_host_key" {
  content  = data.vault_generic_secret.tsa_host_key.data["value"]
  filename = abspath("${path.module}/keys/tsa_host_key")
}

resource "local_file" "tsa_host_key_pub" {
  content  = data.vault_generic_secret.tsa_host_key_pub.data["value"]
  filename = abspath("${path.module}/keys/tsa_host_key.pub")
}

resource "local_file" "worker_key" {
  content  = data.vault_generic_secret.worker_key.data["value"]
  filename = abspath("${path.module}/keys/worker_key")
}

resource "local_file" "worker_key_pub" {
  content  = data.vault_generic_secret.worker_key_pub.data["value"]
  filename = abspath("${path.module}/keys/worker_key.pub")
}

# Setup the docker provider
provider "docker" {
  # For UNIX
  host = "unix:///var/run/docker.sock"
}

# Create a Docker network for Concourse
resource "docker_network" "concourse_network" {
  name = "concourse-network"
}

# Deploy PostgreSQL container for Concourse database
resource "docker_container" "concourse_db" {
  name  = "concourse-db"
  image = "postgres:13"
  env = [
    "POSTGRES_DB=concourse",
    "POSTGRES_USER=concourse_user",
    "POSTGRES_PASSWORD=${data.vault_generic_secret.concourse_db_password.data["password"]}"
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

# Deploy custom Concourse Web container
resource "docker_container" "concourse_web" {
  name  = "concourse-web"
  image = "custom-concourse-web"
  entrypoint = ["/bin/sh", "-c"]
  command = <<-EOC
    "vault login ${VAULT_TOKEN} && "  # Ensure the Vault token is provided securely \
    "vault kv get -field=value secret/concourse/tsa_host_key > /concourse-keys/tsa_host_key && " \
    "vault kv get -field=value secret/concourse/tsa_host_key_pub > /concourse-keys/tsa_host_key.pub && " \
    "vault kv get -field=value secret/concourse/authorized_worker_keys > /concourse-public/authorized_worker_keys && " \
    "dumb-init /usr/local/concourse/bin/concourse web"
  EOC
  env = [
    "VAULT_ADDR=http://127.0.0.1:8200",  # Replace with your Vault server address
    "VAULT_TOKEN=${var.vault_token}",
    "CONCOURSE_POSTGRES_HOST=${docker_container.concourse_db.name}",
    "CONCOURSE_POSTGRES_USER=concourse_user",
    "CONCOURSE_POSTGRES_PASSWORD=${data.vault_generic_secret.concourse_db_password.data["password"]}",
    "CONCOURSE_POSTGRES_DATABASE=concourse",
    "CONCOURSE_EXTERNAL_URL=http://localhost:8080",
    "CONCOURSE_ADD_LOCAL_USER=${data.vault_generic_secret.concourse_user_config.data["add_local_user"]}",
    "CONCOURSE_MAIN_TEAM_LOCAL_USER=${data.vault_generic_secret.concourse_user_config.data["main_team_local_user"]}"
  ]
  networks_advanced {
    name = docker_network.concourse_network.name
  }
  ports {
    internal = 8080
    external = 8080
  }
  depends_on = [docker_container.concourse_db]
  restart = "always"
}

# Deploy custom Concourse Worker container
resource "docker_container" "concourse_worker" {
  name       = "concourse-worker"
  image      = "custom-concourse-worker"
  privileged = true
  entrypoint = ["/bin/sh", "-c"]
  command = <<-EOC
    "vault login ${VAULT_TOKEN} && " \
    "vault kv get -field=value secret/concourse/worker_key > /concourse-keys/worker_key && " \
    "dumb-init /usr/local/concourse/bin/concourse worker" \ 
  EOC
  env = [
    "VAULT_ADDR=http://127.0.0.1:8200",
    "VAULT_TOKEN=${var.vault_token}",
    "CONCOURSE_WORKER_BAGGAGECLAIM_DRIVER=overlay",
    "CONCOURSE_RUNTIME=containerd",
    "CONCOURSE_TSA_HOST=concourse-web:2222"
  ]
  networks_advanced {
    name = docker_network.concourse_network.name
  }
  depends_on = [docker_container.concourse_web]
  restart = "always"
}