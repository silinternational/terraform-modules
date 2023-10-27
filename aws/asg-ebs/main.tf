/*
 * Generate user_data from template file
 */
locals {
  user_data = templatefile("${path.module}/user-data.sh", {
    ecs_cluster_name     = var.ecs_cluster_name
    additional_user_data = var.additional_user_data
    aws_region           = var.aws_region
    aws_access_key       = var.aws_access_key
    aws_secret_key       = var.aws_secret_key
    ebs_device           = var.ebs_device
    ebs_mount_point      = var.ebs_mount_point
    ebs_vol_id           = var.ebs_vol_id
    ebs_mkfs_label       = var.ebs_mkfs_label
    ebs_mkfs_labelflag   = var.ebs_mkfs_labelflag
    ebs_mkfs_extraopts   = var.ebs_mkfs_extraopts
    ebs_fs_type          = var.ebs_fs_type
    ebs_mountopts        = var.ebs_mountopts
  })
  credits = var.cpu_credits == "" ? [] : [var.cpu_credits]
}

/*
 * Create Launch Template
 */
resource "aws_launch_template" "asg_lt" {
  default_version = 1
  ebs_optimized   = false
  name            = "lt-${var.app_name}-${var.app_env}"
  image_id        = var.ami_id
  instance_type   = var.aws_instance["instance_type"]
  key_name        = var.key_name
  user_data       = base64encode(local.user_data)

  block_device_mappings {
    device_name = var.root_device_name
    ebs {
      delete_on_termination = true
      volume_size           = var.aws_instance["volume_size"]
    }
  }

  dynamic "credit_specification" {
    iterator = ii
    for_each = local.credits
    content {
      cpu_credits = ii.value
    }
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = concat([var.default_sg_id], var.additional_security_groups)
  }

  iam_instance_profile {
    name = var.ecs_instance_profile_id
  }

  monitoring {
    enabled = true
  }

  dynamic "tag_specifications" {
    for_each = ["network-interface", "volume"]
    iterator = resource

    content {
      resource_type = resource.value

      tags = var.tags
    }
  }
}

/*
 * Create Auto Scaling Group
 */
resource "aws_autoscaling_group" "asg" {
  name                      = "asg-${var.app_name}-${var.app_env}"
  vpc_zone_identifier       = var.private_subnet_ids
  min_size                  = var.aws_instance["instance_count"]
  max_size                  = var.aws_instance["instance_count"]
  desired_capacity          = var.aws_instance["instance_count"]
  health_check_type         = "EC2"
  health_check_grace_period = "120"
  default_cooldown          = "30"

  launch_template {
    id      = aws_launch_template.asg_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.app_name}-${var.app_env}"
    propagate_at_launch = true
  }

  tag {
    key                 = "app_name"
    value               = var.app_name
    propagate_at_launch = true
  }

  tag {
    key                 = "app_env"
    value               = var.app_env
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
