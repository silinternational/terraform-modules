/*
 * Generate user_data from template file
 */
data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.sh")}"

  vars {
    ecs_cluster_name     = "${var.ecs_cluster_name}"
    efs_dns_name         = "${var.efs_dns_name}"
    mount_point          = "${var.mount_point}"
    additional_user_data = "${var.additional_user_data}"
  }
}

/*
 * Create Launch Configuration
 */
resource "aws_launch_configuration" "as_conf" {
  name_prefix                 = "${var.app_name}-${var.app_env}-"
  image_id                    = "${var.ami_id}"
  instance_type               = "${var.aws_instance["instance_type"]}"
  security_groups             = ["${concat(list(var.default_sg_id), var.additional_security_groups)}"]
  iam_instance_profile        = "${var.ecs_instance_profile_id}"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = "${var.associate_public_ip_address}"

  root_block_device {
    volume_size = "${var.aws_instance["volume_size"]}"
  }

  user_data = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

/*
 * Create Auto Scaling Group
 */
resource "aws_autoscaling_group" "asg" {
  name                      = "asg-${var.app_name}-${var.app_env}"
  vpc_zone_identifier       = ["${var.private_subnet_ids}"]
  min_size                  = "${var.aws_instance["instance_count"]}"
  max_size                  = "${var.aws_instance["instance_count"]}"
  desired_capacity          = "${var.aws_instance["instance_count"]}"
  launch_configuration      = "${aws_launch_configuration.as_conf.id}"
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
    value               = "${var.app_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "app_env"
    value               = "${var.app_env}"
    propagate_at_launch = true
  }
}
