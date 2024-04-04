output "id" {
  value = aws_vpc.vpc.id
}

output "ipv6_association_id" {
  value = aws_vpc.vpc.ipv6_association_id
}

output "ipv6_cidr_block" {
  value = aws_vpc.vpc.ipv6_cidr_block
}

output "vpc_default_sg_id" {
  value = data.aws_security_group.vpc_default_sg.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnet.*.id
}

output "public_subnet_cidr_blocks" {
  value = aws_subnet.public_subnet.*.cidr_block
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet.*.id
}

output "private_subnet_cidr_blocks" {
  value = aws_subnet.private_subnet.*.cidr_block
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.db_subnet_group.name
}

output "aws_zones" {
  value = var.aws_zones
}

output "nat_gateway_ip" {
  value = one(aws_nat_gateway.nat_gateway[*].public_ip)
}
