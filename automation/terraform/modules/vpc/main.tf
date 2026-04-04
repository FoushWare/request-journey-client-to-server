locals {
  name = "${var.project_name}-${var.environment}"
}

# ─────────────────────────────────────────────────────────────
# VPC
# ─────────────────────────────────────────────────────────────
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name}-vpc"
  }
}

# ─────────────────────────────────────────────────────────────
# Internet Gateway
# ─────────────────────────────────────────────────────────────
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${local.name}-igw" }
}

# ─────────────────────────────────────────────────────────────
# Public Subnets (ALB, NAT Gateway)
# ─────────────────────────────────────────────────────────────
resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${local.name}-public-${var.availability_zones[count.index]}"
    "kubernetes.io/role/elb" = "1"
  }
}

# ─────────────────────────────────────────────────────────────
# Private App Subnets (EKS Worker Nodes)
# ─────────────────────────────────────────────────────────────
resource "aws_subnet" "private_app" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name                              = "${local.name}-private-app-${var.availability_zones[count.index]}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# ─────────────────────────────────────────────────────────────
# Private Data Subnets (RDS, ElastiCache)
# ─────────────────────────────────────────────────────────────
resource "aws_subnet" "private_data" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.data_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${local.name}-private-data-${var.availability_zones[count.index]}"
  }
}

# ─────────────────────────────────────────────────────────────
# Elastic IP for NAT Gateway (one per AZ for HA)
# ─────────────────────────────────────────────────────────────
resource "aws_eip" "nat" {
  count  = length(var.availability_zones)
  domain = "vpc"
  tags   = { Name = "${local.name}-nat-eip-${count.index}" }
}

# ─────────────────────────────────────────────────────────────
# NAT Gateway (one per AZ for HA)
# ─────────────────────────────────────────────────────────────
resource "aws_nat_gateway" "main" {
  count         = length(var.availability_zones)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = { Name = "${local.name}-nat-${var.availability_zones[count.index]}" }

  depends_on = [aws_internet_gateway.main]
}

# ─────────────────────────────────────────────────────────────
# Route Tables
# ─────────────────────────────────────────────────────────────

# Public route table → Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = { Name = "${local.name}-public-rt" }
}

resource "aws_route_table_association" "public" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private route tables (one per AZ) → NAT Gateway
resource "aws_route_table" "private" {
  count  = length(var.availability_zones)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = { Name = "${local.name}-private-rt-${var.availability_zones[count.index]}" }
}

resource "aws_route_table_association" "private_app" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "private_data" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.private_data[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# ─────────────────────────────────────────────────────────────
# VPC Flow Logs (for security auditing)
# ─────────────────────────────────────────────────────────────
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/${local.name}-flow-logs"
  retention_in_days = 30
}

resource "aws_iam_role" "vpc_flow_logs" {
  name = "${local.name}-vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "vpc-flow-logs.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "vpc_flow_logs" {
  role       = aws_iam_role.vpc_flow_logs.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.vpc_flow_logs.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}
