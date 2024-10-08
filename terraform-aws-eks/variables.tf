variable "aws_region" {
  description = "The AWS region to deploy the resources"
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "example-eks-cluster"
}

variable "node_instance_type" {
  description = "EC2 instance type for worker nodes"
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  default     = 2
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  default     = 5
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  default     = 1
}

