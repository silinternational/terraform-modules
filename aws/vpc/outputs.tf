// Default Security Group ID
output "vpc_default_sg_id" {
  value = "${data.aws_security_group.vpc_default_sg.id}"
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public_subnet.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private_subnet.*.id}"]
}
