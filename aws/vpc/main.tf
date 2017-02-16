/*
 * Create VPC using app name and env to name it
 */
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    app_name = "${var.tag_app_name}"
    app_env = "${var.tag_app_env}"
    Name = "vpc-${var.tag_app_name}-${var.tag_app_env}"
  }
}

/*
 * Get default security group for reference later
 */
data "aws_security_group" "vpc_default_sg" {
  name = "default"
  vpc_id = "${aws_vpc.vpc.id}"
}

/*
 * Create public and private subnets for each availability zone
 */
resource "aws_subnet" "public_subnet" {
  count = "${length(var.aws_zones)}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${element(var.aws_zones, count.index)}"
  cidr_block = "10.0.${(count.index + 1) * 10}.0/24"
  tags {
    Name = "public-${element(var.aws_zones, count.index)}"
  }
}
resource "aws_subnet" "private_subnet" {
  count = "${length(var.aws_zones)}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${element(var.aws_zones, count.index)}"
  cidr_block = "10.0.${(count.index + 1) * 11}.0/24"
  tags {
    Name = "private-${element(var.aws_zones, count.index)}"
  }
}

/*
 * Create internet gateway for VPC
 */
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"
}

/*
 * Create NAT gateway and allocate Elastic IP for it
 */
resource "aws_eip" "gateway_eip" {

}
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = "${aws_eip.gateway_eip.id}"
  //subnet_id = "${aws_subnet.public-1c.id}"
  subnet_id = "${aws_subnet.public_subnet.0.id}"
  depends_on = ["aws_internet_gateway.internet_gateway"]
}

/*
 * Routes for private subnets to use NAT gateway
 */
resource "aws_route_table" "nat_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"
}
resource "aws_route" "nat_route" {
  route_table_id = "${aws_route_table.nat_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.nat_gateway.id}"
}
resource "aws_route_table_association" "private_route" {
  count = "${length(var.aws_zones)}"
  subnet_id = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.nat_route_table.id}"
}

/*
 * Routes for public subnets to use internet gateway
 */
resource "aws_route_table" "igw_route_table" {
  vpc_id = "${aws_vpc.vpc.id}"
}
resource "aws_route" "igw_route" {
  route_table_id = "${aws_route_table.igw_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.internet_gateway.id}"
}
resource "aws_route_table_association" "public_route" {
  count = "${length(var.aws_zones)}"
  subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.igw_route_table.id}"
}
