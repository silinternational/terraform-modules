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

  dynamic "volume" {
    for_each = var.volumes
    content {
      host_path = lookup(volume.value, "host_path", null)
      name      = volume.value.name

      dynamic "docker_volume_configuration" {
        for_each = lookup(volume.value, "docker_volume_configuration", [])
        content {
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
          driver        = lookup(docker_volume_configuration.value, "driver", null)
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
          labels        = lookup(docker_volume_configuration.value, "labels", null)
          scope         = lookup(docker_volume_configuration.value, "scope", null)
        }
      }

      dynamic "efs_volume_configuration" {
        for_each = lookup(volume.value, "efs_volume_configuration", [])
        content {
          file_system_id = lookup(efs_volume_configuration.value, "file_system_id", null)
          root_directory = lookup(efs_volume_configuration.value, "root_directory", null)
        }
      }
    }
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

