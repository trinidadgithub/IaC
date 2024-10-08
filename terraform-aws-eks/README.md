# Terraform AWS EKS Cluster

This project provides a Terraform configuration to deploy an AWS Elastic Kubernetes Service (EKS) cluster. The cluster is scalable and configurable using Terraform variables.

## Prerequisites

- Terraform v0.13+
- AWS CLI configured
- IAM role with appropriate permissions

## Usage

Clone this repository and run:

```bash
terraform init
terraform validate
terraform plan
# If everything looks good then...
terraform apply
```
## Variables

| Variable           | Description                           | Default            |
|--------------------|---------------------------------------|--------------------|
| `aws_region`       | AWS region to deploy the resources    | `us-west-2`        |
| `cluster_name`     | Name of the EKS cluster               | `example-eks-cluster` |
| `node_instance_type` | EC2 instance type for worker nodes   | `t3.medium`        |
| `desired_capacity` | Desired number of worker nodes        | 2                  |
| `max_size`         | Maximum number of worker nodes        | 5                  |
| `min_size`         | Minimum number of worker nodes        | 1                  |

## Outputs

| Output               | Description                        |
|----------------------|------------------------------------|
| `eks_cluster_name`    | The name of the EKS cluster        |
| `eks_cluster_endpoint`| The endpoint of the EKS cluster    |

## Prerequisites

Before you begin, ensure you have the following installed:

- **Terraform**: Version 0.13 or higher. [Download Terraform](https://www.terraform.io/downloads.html)
- **AWS CLI**: AWS Command Line Interface configured with appropriate credentials. [AWS CLI Installation](https://aws.amazon.com/cli/)
- **IAM Role**: An AWS IAM role with sufficient permissions to create EKS clusters and manage the associated resources (e.g., EC2, VPC, and IAM).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

