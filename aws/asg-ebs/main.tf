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
}

/*
 * Create Launch Configuration
 */
resource "aws_launch_configuration" "as_conf" {
  name_prefix                 = "${var.app_name}-${var.app_env}-"
  image_id                    = var.ami_id
  instance_type               = var.aws_instance["instance_type"]
  security_groups             = concat([var.default_sg_id], var.additional_security_groups)
  iam_instance_profile        = var.ecs_instance_profile_id
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address

  root_block_device {
    volume_size = var.aws_instance["volume_size"]
  }

  user_data = local.user_data

  lifecycle {
    create_before_destroy = true
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
  launch_configuration      = aws_launch_configuration.as_conf.id
  health_check_type         = "EC2"
  health_check_grace_period = "120"
  default_cooldown          = "30"

  lifecycle {
    create_before_destroy = true
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
}

