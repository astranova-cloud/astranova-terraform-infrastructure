########################################
# EKS Cluster
########################################

resource "aws_eks_cluster" "eks_cluster" {
  name     = "astranova-${var.environment}-eks"
  role_arn = var.eks_cluster_role_arn
  version  = "1.29"

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    Name        = "astranova-${var.environment}-eks"
    Environment = var.environment
    Project     = "AstraNova"
    ManagedBy   = "Terraform"
  }
}

########################################
# EKS Managed Node Group
########################################

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "astranova-${var.environment}-node-group"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 2
  }

  instance_types = ["t3.small"]
  capacity_type  = "ON_DEMAND"

  ami_type = "AL2_x86_64"

  tags = {
    Name        = "astranova-${var.environment}-node-group"
    Environment = var.environment
    Project     = "AstraNova"
    ManagedBy   = "Terraform"
  }

  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
}