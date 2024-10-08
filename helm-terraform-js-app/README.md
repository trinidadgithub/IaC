# Helm & Terraform JavaScript Application Deployment

This project demonstrates how to deploy a simple JavaScript (Node.js) application to a Kubernetes cluster using **Helm** and **Terraform**. The application is containerized with Docker, deployed to an AWS EKS (Elastic Kubernetes Service) cluster, and managed via Helm charts.

## Project Structure

```bash
helm-terraform-js-app/
├── helm/
│   └── myapp/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
│           ├── deployment.yaml
│           ├── service.yaml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── provider.tf
├── app/
│   └── server.js
├── Dockerfile
├── LICENSE
└── README.md
```
## Prerequisites

- AWS CLI: For managing AWS resources. https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
- Terraform: For infrastructure as code. https://www.terraform.io/downloads.html
- Helm: For managing Kubernetes applications. https://helm.sh/docs/intro/install/
- Kubernetes Cluster (EKS): You need a running EKS cluster.
- Docker: For building and pushing the containerized application. https://docs.docker.com/get-docker/
- kubectl: For interacting with the Kubernetes cluster.

## Steps

### 1. Clone the repository:

```bash
   git clone https://github.com/your-username/helm-terraform-js-app.git
   cd helm-terraform-js-app
```
### 2. Build and Push the Docker Image:
```bash
   docker build -t your-dockerhub-username/myapp .
   docker push your-dockerhub-username/myapp:latest

   Update the `values.yaml` file in the Helm chart to point to your Docker image repository.
```
### 3. Helm Chart Overview

The **Helm chart** for the Node.js application is located in the `helm/myapp/` directory and includes the following key files:
- **Chart.yaml**: Contains metadata about the chart (name, version, description).
- **values.yaml**: Holds default configuration values, such as image repository and replica counts.
- **templates/deployment.yaml**: Defines the Kubernetes Deployment for the Node.js app.
- **templates/service.yaml**: Defines the Kubernetes Service to expose the application.

### 4. Validate the Helm Chart:

   Before deploying, you can validate the Helm chart by running the following commands:
```bash
   helm lint ./helm/myapp
```
   This command will check the chart for syntax errors and best practices.

   To render the Helm templates without actually deploying them, run:
```bash
   helm template myapp ./helm/myapp --namespace default
```
   This will output the rendered Kubernetes manifests based on the Helm templates and values.

### 5. Validate the Kubernetes Manifests:

   After rendering the templates, you can further validate the Kubernetes manifests using `kubectl` without applying them:
```bash
   helm template myapp ./helm/myapp --namespace default | kubectl apply --dry-run=client -f -
```
   This ensures that the generated YAML files are valid and would apply successfully if you were to deploy them.

### 6. Configure Terraform:

   Navigate to the `terraform/` directory and update any necessary variables in `variables.tf`, such as the AWS region or Docker image repository.

### 7. Initialize and Apply Terraform:
```bash
   cd terraform/
   terraform init
   terraform apply
```
   Terraform will use Helm to deploy the Node.js application to your Kubernetes cluster.

## Verify Deployment

Once the Terraform configuration is applied, you can verify that the application is running by checking the Kubernetes pods and services:
```bash
   kubectl get pods
   kubectl get svc
```
   Access your application by using the service's external IP or configure an ingress to expose it externally.

## Helm Hooks

This project also includes Helm hooks that perform pre-install and pre-upgrade validation checks, ensuring that specific conditions (like the availability of certain services) are met before the application is deployed.

## License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.
