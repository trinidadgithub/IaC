resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = aws_subnet.eks_subnet[*].id
  }

  depends_on = [aws_iam_role_policy_attachment.eks_policy_attachment]
}

resource "aws_iam_role" "eks_role" {
  name = "${var.cluster_name}-eks-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_policy_attachment" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_subnet" "eks_subnet" {
  count = 2  # Adjust as necessary
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index)

  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "eks-subnet-${count.index + 1}"
  }
}

resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "eks-vpc"
  }
}

provider "aws" {
  region = var.aws_region
}

# Declare the eks-cluster module
module "eks_cluster" {
  source           = "./modules/eks-cluster"
  cluster_name     = var.cluster_name
  node_instance_type = var.node_instance_type
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size

  role_arn    = aws_iam_role.eks_role.arn
  subnet_ids  = aws_subnet.eks_subnet[*].id
}


# Data source for availability zones
data "aws_availability_zones" "available" {}