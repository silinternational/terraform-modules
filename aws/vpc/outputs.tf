// Default Security Group ID
output "id" {
  value = "${aws_vpc.vpc.id}"
}
output "vpc_default_sg_id" {
  value = "${data.aws_security_group.vpc_default_sg.id}"
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public_subnet.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private_subnet.*.id}"]
}

output "db_subnet_group_name" {
  value = "${aws_db_subnet_group.db_subnet_group.name}"
}
