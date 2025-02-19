/*
 * Create VPC using app name and env to name it
 */
resource "aws_vpc" "vpc" {
  cidr_block                       = var.vpc_cidr_block
  enable_dns_hostnames             = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = {
    Name     = "vpc-${var.app_name}-${var.app_env}"
    app_name = var.app_name
    app_env  = var.app_env
  }
}

/*
 * Get default security group for reference later
 */
data "aws_security_group" "vpc_default_sg" {
  name   = "default"
  vpc_id = aws_vpc.vpc.id
}

/*
 * Create public and private subnets for each availability zone
 */

locals {
  ipv6_cidr_block = aws_vpc.vpc.ipv6_cidr_block
  public_subnets  = var.enable_ipv6 ? cidrsubnets(cidrsubnet(local.ipv6_cidr_block, 4, 0), 4, 4, 4, 4, 4, 4, 4, 4) : []
  private_subnets = var.enable_ipv6 ? cidrsubnets(cidrsubnet(local.ipv6_cidr_block, 4, 1), 4, 4, 4, 4, 4, 4, 4, 4) : []
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.aws_zones)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(var.aws_zones, count.index)
  cidr_block        = element(var.public_subnet_cidr_blocks, count.index)
  ipv6_cidr_block   = var.enable_ipv6 ? element(local.public_subnets, count.index) : null

  tags = {
    Name     = "public-${element(var.aws_zones, count.index)}"
    app_name = var.app_name
    app_env  = var.app_env
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.aws_zones)
  vpc_id            = aws_vpc.vpc.id
  availability_zone = element(var.aws_zones, count.index)
  cidr_block        = element(var.private_subnet_cidr_blocks, count.index)
  ipv6_cidr_block   = var.enable_ipv6 ? element(local.private_subnets, count.index) : null

  tags = {
    Name     = "private-${element(var.aws_zones, count.index)}"
    app_name = var.app_name
    app_env  = var.app_env
  }
}


/*
 * Create internet gateway(s) for VPC
 */
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name     = "IGW-${var.app_name}-${var.app_env}"
    app_name = var.app_name
    app_env  = var.app_env
  }
}

resource "aws_egress_only_internet_gateway" "ipv6" {
  count = var.enable_ipv6 ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name     = "egress-${var.app_name}-${var.app_env}"
    app_name = var.app_name
    app_env  = var.app_env
  }
}

resource "aws_route" "private_ipv6" {
  count = var.enable_ipv6 ? 1 : 0

  route_table_id              = aws_route_table.private_route_table.id
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = one(aws_egress_only_internet_gateway.ipv6[*].id)
}


/*
 * Create NAT gateway and allocate Elastic IP for it
 */
resource "aws_eip" "gateway_eip" {
  tags = {
    Name     = "EIP-${var.app_name}-${var.app_env}"
    app_name = var.app_name
    app_env  = var.app_env
  }
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  count = var.create_nat_gateway ? 1 : 0

  allocation_id = aws_eip.gateway_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
  depends_on    = [aws_internet_gateway.internet_gateway]

  tags = {
    Name     = "NAT-${var.app_name}-${var.app_env}"
    app_name = var.app_name
    app_env  = var.app_env
  }
}

/*
 * Set use_transit_gateway to true create transit gateway attachments in the private subnets and
 * route traffic to the TGW instead of NAT GW.
 * Should be used when create_nat_gateway=false.
 */
resource "aws_ec2_transit_gateway_vpc_attachment" "transit_gateway" {
  count = var.use_transit_gateway ? 1 : 0

  subnet_ids                                      = aws_subnet.private_subnet.*.id
  transit_gateway_id                              = var.transit_gateway_id
  vpc_id                                          = aws_vpc.vpc.id
  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation

  tags = {
    Name     = "TGW-${var.app_name}-${var.app_env}"
    app_name = var.app_name
    app_env  = var.app_env
  }
}

/*
 * Routes for private subnets to use NAT or Transit gateway
 */
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name     = "RT-private-${var.app_name}-${var.app_env}"
    app_name = var.app_name
    app_env  = var.app_env
  }
}

/*
 * Refactoring information to note that we renamed aws_route_table.nat_route_table to aws_route_table.private_route_table
 * This prevents the resource from being destroyed and recreated. Should be kept at least until the next major revision
 * but probably should remain permanently.
 */
moved {
  from = aws_route_table.nat_route_table
  to   = aws_route_table.private_route_table
}

resource "aws_route" "nat_route" {
  count = var.create_nat_gateway ? 1 : 0

  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = one(aws_nat_gateway.nat_gateway[*].id)
}

resource "aws_route" "transit_gateway" {
  count = var.use_transit_gateway ? 1 : 0

  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.transit_gateway_id
}

resource "aws_route_table_association" "private_route" {
  count          = length(var.aws_zones)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}

/*
 * Routes for public subnets to use internet gateway
 */
resource "aws_route_table" "igw_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name     = "RT-public-${var.app_name}-${var.app_env}"
    app_name = var.app_name
    app_env  = var.app_env
  }
}

resource "aws_route" "igw_route" {
  route_table_id         = aws_route_table.igw_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route" "public_ipv6" {
  count = var.enable_ipv6 ? 1 : 0

  route_table_id              = aws_route_table.igw_route_table.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public_route" {
  count          = length(var.aws_zones)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.igw_route_table.id
}

/*
 * Create DB Subnet Group for private subnets
 */
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-${var.app_name}-${var.app_env}"
  subnet_ids = aws_subnet.private_subnet.*.id

  tags = {
    Name     = "db-subnet-${var.app_name}-${var.app_env}"
    app_name = var.app_name
    app_env  = var.app_env
  }
}

