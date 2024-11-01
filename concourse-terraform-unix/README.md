# Concourse CI/CD Deployment with Vault Integration

### Project Overview

This project is designed to deploy Concourse CI/CD with Docker containers using Terraform, integrating HashiCorp Vault for secure key and secret management. The custom Docker containers for the Concourse web and worker nodes retrieve secrets from Vault at runtime.Concourse CI/CD Deployment with Vault Integration

**Directory Structure**

```bash
.
├── generate_keys.sh           # Script to generate RSA keys for Concourse
├── build_containers.sh        # Script to build custom Docker containers
├── keys/                      # Directory for storing generated key files
├── variables.tf               # Terraform variable definitions
├── environment_vars.sh        # Environment variables setup script
├── vault_commands.sh          # Script for Vault-related operations
├── retrieve-keys.sh           # Script to retrieve keys at runtime (Docker runtime)
├── put-keys.sh                # Script to put keys into Vault
├── main.tf                    # Main Terraform configuration
├── Dockerfile.web             # Dockerfile for building the Concourse web container
├── Dockerfile.worker          # Dockerfile for building the Concourse worker container
```

**Prerequisites**
- Docker: Ensure Docker is installed and running.
- Terraform: Version ~> 2.23.0 of kreuzwerker/docker provider is used.
- Vault: Running instance of HashiCorp Vault.
- Linux based host like Ubuntu

**Steps to Run the Project**

**1. Generate keys**
Run the generate_keys.sh script to generate RSA keys for Concourse.

```bash
./generate_keys.sh
```

This script will create key files in the keys/ directory.

**2. Store Keys in Vault**

Use the put-keys.sh script to store generated keys into Vault.

```bash
./put-keys.sh
```
**3. Build Docker Containers**

Use the build_containers.sh script to build the custom Docker images for Concourse web and worker nodes.

```bash
./build_containers.sh
```

**4. Deploy with Terraform**

Ensure your VAULT_TOKEN is set in your environment and deploy with Terraform.

```bash
terraform init
terraform apply
```

**5. Environment Variables**

Use the environment_vars.sh script to set up necessary environment variables.

```bash
source environment_vars.sh
```

### Docker Containers
**Dockerfile.web**

This Dockerfile builds a custom image for the Concourse web node. It includes:

- Directories for key storage.
- Entrypoint configured to run Concourse web.

### Dockerfile.worker

This Dockerfile builds a custom image for the Concourse worker node. It includes:

- Directories for key storage.
- Entrypoint configured to run Concourse worker.

### Scripts Overview
**generate_keys.sh**
Generates RSA key pairs for use in Concourse.
**build_containers.sh**
Builds custom Docker images for Concourse web and worker nodes.
**retrieve-keys.sh**
Retrieves keys at container runtime (to be executed as part of Docker's command in Terraform).
**put-keys.sh**
Uploads generated keys to Vault.
**vault_commands.sh**
Contains commands for interacting with Vault.

### Notes

- Ensure Vault is running and accessible at the address specified in main.tf.
- Secure handling of VAULT_TOKEN is critical. Store it as an environment variable or use Vault CLI for secure authentication.

**Example Command**

To retrieve keys at runtime within Docker:

```bash
vault login ${VAULT_TOKEN} && vault kv get -field=value secret/concourse/tsa_host_key > /concourse-keys/tsa_host_key
```

This README provides a comprehensive guide to set up and run the project, detailing the use of Docker, Terraform, and Vault integration.