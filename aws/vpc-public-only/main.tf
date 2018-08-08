/*
 * Create VPC using app name and env to name it
 */
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"

  tags = {
    Name     = "vpc-${var.app_name}-${var.app_env}"
    app_name = "${var.app_name}"
    app_env  = "${var.app_env}"
  }
}

/*
 * Get default security group for reference later
 */
data "aws_security_group" "vpc_default_sg" {
  name   = "default"
  vpc_id = "${aws_vpc.vpc.id}"
}

/*
 * Create public subnets for each availability zone
 */
resource "aws_subnet" "public_subnet" {
  count             = "${length(var.aws_zones)}"
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${element(var.aws_zones, count.index)}"
  cidr_block        = "10.0.${(count.index + 1) * 10}.0/24"

  tags {
    Name     = "public-${element(var.aws_zones, count.index)}"
    app_name = "${var.app_name}"
    app_env  = "${var.app_env}"
  }
}

/*
 * Create internet gateway for VPC
 */
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name     = "IGW-${var.app_name}-${var.app_env}"
    app_name = "${var.app_name}"
    app_env  = "${var.app_env}"
  }
}

/*
 * Routes for public subnets to use internet gateway
 */
resource "aws_route_table" "igw_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name     = "RT-public-${var.app_name}-${var.app_env}"
    app_name = "${var.app_name}"
    app_env  = "${var.app_env}"
  }
}

resource "aws_route" "igw_route" {
  route_table_id         = "${aws_route_table.igw_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet_gateway.id}"
}

resource "aws_route_table_association" "public_route" {
  count          = "${length(var.aws_zones)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.igw_route_table.id}"
}

/*
 * Create DB Subnet Group for public subnets
 */
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-${var.app_name}-${var.app_env}"
  subnet_ids = ["${aws_subnet.public_subnet.*.id}"]

  tags {
    Name     = "db-subnet-${var.app_name}-${var.app_env}"
    app_name = "${var.app_name}"
    app_env  = "${var.app_env}"
  }
}
