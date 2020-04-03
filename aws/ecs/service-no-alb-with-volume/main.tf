/*
 * Get task definition data
 */
data "aws_ecs_task_definition" "td" {
  task_definition = aws_ecs_task_definition.td.family
  depends_on      = [aws_ecs_task_definition.td]
}

/*
 * Create task definition
 */
resource "aws_ecs_task_definition" "td" {
  family                = "${var.service_name}-${var.service_env}"
  container_definitions = var.container_def_json
  task_role_arn         = var.task_role_arn
  network_mode          = var.network_mode

  volume {
    name      = var.volume_name
    host_path = var.volume_host_path
  }
}

/*
 * Create ECS Service
 */
resource "aws_ecs_service" "service" {
  name                               = var.service_name
  cluster                            = var.cluster_id
  desired_count                      = var.desired_count
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  # Track the latest ACTIVE revision
  task_definition = "${aws_ecs_task_definition.td.family}:${max(
    aws_ecs_task_definition.td.revision,
    data.aws_ecs_task_definition.td.revision,
  )}"
}

