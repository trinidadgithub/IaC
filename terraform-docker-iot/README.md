# IoT Device Package with Terraform and Docker

This project demonstrates the deployment of an IoT device package using **Docker** and **Terraform**. The package includes secure communication with AWS IoT services, leveraging certificates and policies, and is containerized to ensure consistent deployment across environments.

---

## **Project Structure**
```

terraform-docker-iot/
├── README.md # This document 
├── main.tf # Terraform configuration for Docker deployment 
├── Dockerfile # Dockerfile to containerize the IoT package 
├── start.sh # Script to initialize the IoT package.  Must be downloaded
├── root-CA.crt # Root certificate for AWS IoT.  Must be downloaded 
├── iot-thing.cert.pem # Device certificate for AWS IoT authentication.  Must be downloaded 
├── iot-thing-Policy # IoT policy configuration.  Must be downloaded 
└── requirements.txt # Python dependencies (if applicable)

```

---

## **Prerequisites**

1. **Docker**: Install Docker from [Docker's official website](https://docs.docker.com/get-docker/).
2. **Terraform**: Install Terraform from [Terraform's website](https://www.terraform.io/downloads).
3. **AWS IoT Core SDK**: You must download and set up the AWS IoT Core Python SDK. [AWS IoT Core SDK](https://docs.aws.amazon.com/iot/latest/developerguide/iot-sdks.html)
4. **AWS IoT Configuration**: Ensure your AWS IoT policy, certificates, and device settings are correctly configured.

---

## **How to Build and Deploy the IoT Package**

### **Step 1: Clone the Repository**

```bash
git clone <your-repo-url>
cd terraform-docker-iot
# Note:  The AWS IoT Core SDK for Python contains everything you need.  
#        Unzip the contents to the same directory as main.tf.  
```

### **Step 2: Initialize Terraform**

```bash
terraform init
```
This command downloads the necessary Terraform providers.

### **Step 3: Build and Deploy the Docker Container**

Use the following commands to validate, plan, and build the Docker image and start the container:

```bash
terraform validate
terraform plan
# When you are ready
terraform apply
```
Type yes when prompted to confirm the deployment.

### **Step 4: Verify the Running Container**

Check if the container is running using:
```bash
docker ps
```
You can view the container logs with:

```bash
docker logs <container_id>
```
## Dockerfile Overview

The Dockerfile installs the necessary system packages, including Git, and sets up the Python environment for the IoT device.

dockerfile...
```bash
FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

COPY . /app

RUN if [ -f requirements.txt ]; then pip install -r requirements.txt; fi

RUN chmod +x /app/start.sh

EXPOSE 8883

CMD ["./start.sh"]
```
### Terraform Configuration Overview

The main.tf file defines the Docker resources required to build and run the container.

hcl...
```bash
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

resource "docker_image" "iot_image" {
  name = "my-iot-project:latest"
  build {
    path = "${path.module}"
  }
}

resource "docker_container" "iot_container" {
  name  = "iot-project-container"
  image = docker_image.iot_image.name

  ports {
    internal = 8883
    external = 8883
  }

  volumes {
    host_path      = "${abspath("${path.module}/root-CA.crt")}"
    container_path = "/app/root-CA.crt"
  }

  volumes {
    host_path      = "${abspath("${path.module}/iot-thing.cert.pem")}"
    container_path = "/app/iot-thing.cert.pem"
  }

  volumes {
    host_path      = "${abspath("${path.module}/iot-thing-Policy")}"
    container_path = "/app/iot-thing-Policy"
  }

  restart = "always"
}
```

### Troubleshooting
1. Container Keeps Restarting

- Check the logs with:

```bash
    docker logs <container_id>
    If you see "git: command not found", ensure the Docker image includes Git (as demonstrated in the Dockerfile).
```
2. Permission Issues with Docker

    If Docker commands require sudo, try running:

    ```bash
    sudo terraform apply

3. Terraform Volume Mount Issues

    Ensure all volume paths are absolute. Terraform uses ${abspath()} to resolve relative paths.
