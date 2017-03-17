output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.ecs_cluster.id}"
}

output "ecs_cluster_name" {
  value = "${aws_ecs_cluster.ecs_cluster.name}"
}

output "ecs_instance_role_id" {
  value = "${aws_iam_role.ecsInstanceRole.id}"
}

output "ecs_instance_profile_id" {
  value = "${aws_iam_instance_profile.ecsInstanceProfile.id}"
}

/*output "ecs_service_role_arn" {
  value = "${aws_iam_role.ecsServiceRole.arn}"
}*/

output "ami_id" {
  value = "${data.aws_ami.ecs_ami.id}"
}
