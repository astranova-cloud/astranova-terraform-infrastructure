provider "aws" {
  region = "us-east-1"
}

########################################
# VPC Module
########################################

module "vpc" {
  source = "../../modules/vpc"

  environment = "dev"

  vpc_cidr = "10.0.0.0/16"

  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnets = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}

########################################
# IAM Module
########################################

module "iam" {
  source      = "../../modules/iam"
  environment = "dev"
}

########################################
# EKS Module
########################################

module "eks" {
  source = "../../modules/eks"

  environment          = "dev"
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn    = module.iam.eks_node_role_arn
}
########################################
# DEV Outputs
########################################

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}