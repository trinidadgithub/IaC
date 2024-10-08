variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "node_instance_type" {
  description = "The instance type for the worker nodes"
  type        = string
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "role_arn" {
  description = "ARN of the IAM role for the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}



