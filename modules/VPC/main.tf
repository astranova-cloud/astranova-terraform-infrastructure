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
########################################
# Public Route Table
########################################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.astranova_vpc.id

  tags = {
    Name        = "astranova-${var.environment}-public-rt"
    Environment = var.environment
    Project     = "AstraNova"
    ManagedBy   = "Terraform"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.astranova_igw.id
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}
########################################
# Private Route Table
########################################

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.astranova_vpc.id

  tags = {
    Name        = "astranova-${var.environment}-private-rt"
    Environment = var.environment
    Project     = "AstraNova"
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}