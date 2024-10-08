# Declare VPC for the EKS Cluster
resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "eks-vpc"
  }
}

# Fetch availability zones for the AWS region
data "aws_availability_zones" "available" {
  state = "available"
}

# Create subnets for the EKS cluster
resource "aws_subnet" "eks_subnet" {
  count = 2  # Adjust the number of subnets as needed
  vpc_id     = aws_vpc.eks_vpc.id
  cidr_block = cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index)

  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "eks-subnet-${count.index + 1}"
  }
}

# IAM role for the EKS Cluster
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

# Attach the necessary IAM policies to the role
resource "aws_iam_role_policy_attachment" "eks_policy_attachment" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Create the EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = aws_subnet.eks_subnet[*].id
  }

  depends_on = [aws_iam_role_policy_attachment.eks_policy_attachment]
}
