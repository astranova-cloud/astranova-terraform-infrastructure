########################################
# VPC
########################################

resource "aws_vpc" "astranova_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "astranova-${var.environment}-vpc"
    Environment = var.environment
    Project     = "AstraNova"
    ManagedBy   = "Terraform"
  }
}

########################################
# Internet Gateway
########################################

resource "aws_internet_gateway" "astranova_igw" {
  vpc_id = aws_vpc.astranova_vpc.id

  tags = {
    Name        = "astranova-${var.environment}-igw"
    Environment = var.environment
    Project     = "AstraNova"
    ManagedBy   = "Terraform"
  }
}

########################################
# Public Subnets
########################################

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.astranova_vpc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "astranova-${var.environment}-public-${count.index + 1}"
    Environment = var.environment
    Project     = "AstraNova"
    Tier        = "Public"
    ManagedBy   = "Terraform"
  }
}

########################################
# Private Subnets
########################################

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.astranova_vpc.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "astranova-${var.environment}-private-${count.index + 1}"
    Environment = var.environment
    Project     = "AstraNova"
    Tier        = "Private"
    ManagedBy   = "Terraform"
  }
}