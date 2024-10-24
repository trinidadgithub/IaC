# keys.tf

resource "tls_private_key" "tsa_host_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_private_key" "worker_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_private_key" "session_signing_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

output "tsa_host_private_key_pem" {
  value     = tls_private_key.tsa_host_key.private_key_pem
  sensitive = true
}

output "tsa_host_public_key_pem" {
  value = tls_private_key.tsa_host_key.public_key_pem
}

output "worker_private_key_pem" {
  value     = tls_private_key.worker_key.private_key_pem
  sensitive = true
}

output "worker_public_key_pem" {
  value = tls_private_key.worker_key.public_key_pem
}

output "session_signing_private_key_pem" {
  value     = tls_private_key.session_signing_key.private_key_pem
  sensitive = true
}
