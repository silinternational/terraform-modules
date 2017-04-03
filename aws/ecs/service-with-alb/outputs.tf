/*
 * Task definition outputs
 */
output "task_def_arn" {
  value = "${aws_ecs_task_definition.td.arn}"
}
output "task_def_family" {
  value = "${aws_ecs_task_definition.td.family}"
}
output "task_def_revision" {
  value = "${aws_ecs_task_definition.td.revision}"
}
output "task_def_revision_via_data" {
  value = "${data.aws_ecs_task_definition.td.revision}"
}

/*
 * Service outputs
 */
output "service_id" {
  value = "${aws_ecs_service.service.id}"
}
output "service_name" {
  value = "${aws_ecs_service.service.name}"
}
output "service_cluster" {
  value = "${aws_ecs_service.service.cluster}"
}
output "service_role" {
  value = "${aws_ecs_service.service.iam_role}"
}
output "service_desired_count" {
  value = "${aws_ecs_service.service.desired_count}"
}

/*
 * ALB outputs
 */
output "alb_id" {
  value = "${aws_alb.alb.id}"
}
output "alb_arn" {
  value = "${aws_alb.alb.arn}"
}
output "alb_dns_name" {
  value = "${aws_alb.alb.dns_name}"
}
output "tg_id" {
  value = "${aws_alb_target_group.tg.id}"
}
output "tg_arn" {
  value = "${aws_alb_target_group.tg.arn}"
}
