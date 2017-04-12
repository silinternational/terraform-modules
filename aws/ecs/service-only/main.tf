 /*
  * Create ECS IAM Service Role and Policy
  */
resource "aws_iam_role" "ecsServiceRole" {
  name = "ecsServiceRole"
  assume_role_policy = "${var.ecsServiceRoleAssumeRolePolicy}"
}

resource "aws_iam_role_policy" "ecsServiceRolePolicy" {
  name = "ecsServiceRolePolicy"
  role = "${aws_iam_role.ecsServiceRole.id}"
  policy = "${var.ecsServiceRolePolicy}"
}

/*
 * Get task definition data
 */
data "aws_ecs_task_definition" "td" {
  task_definition = "${aws_ecs_task_definition.td.family}"
}

/*
 * Create task definition
 */
resource "aws_ecs_task_definition" "td" {
  family = "${var.service_name}-${var.service_env}"
  container_definitions = "${var.container_def_json}"
  task_role_arn = "${var.task_role_arn}"
  network_mode = "${var.network_mode}"
}

/*
 * Create ECS Service
 */
 resource "aws_ecs_service" "service" {
   name = "${var.service_name}"
   cluster = "${var.cluster_id}"
   desired_count = "${var.desired_count}"
   iam_role = "${aws_iam_role.ecsServiceRole.arn}"
   depends_on = ["aws_iam_role_policy.ecsServiceRolePolicy"]
   deployment_maximum_percent = "${var.deployment_maximum_percent}"
   deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"

   placement_strategy {
     type = "spread"
     field = "instanceId"
   }

   load_balancer {
     target_group_arn = "${var.tg_arn}"
     container_name = "${var.lb_container_name}"
     container_port = "${var.lb_container_port}"
   }

   # Track the latest ACTIVE revision
   task_definition = "${aws_ecs_task_definition.td.family}:${max("${aws_ecs_task_definition.td.revision}", "${data.aws_ecs_task_definition.td.revision}")}"
 }
