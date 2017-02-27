resource "aws_launch_configuration" "as_conf" {
    image_id = "${var.ami_id}"
    instance_type = "${var.aws_instance["instance_type"]}"
    security_groups = ["${var.default_sg_id}"]
    iam_instance_profile = "${var.ecs_instance_profile_id}"
    root_block_device {
      volume_size = "${var.aws_instance["volume_size"]}"
    }
    user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config
EOF

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "asg" {
  name = "asg-${var.tag_app_name}-${var.tag_app_env}-${aws_launch_configuration.as_conf.name}"
  availability_zones = "${var.aws_zones}"
  vpc_zone_identifier = ["${var.private_subnet_ids}"]
  min_size = "${var.aws_instance["instance_count"]}"
  max_size = "${var.aws_instance["instance_count"]}"
  desired_capacity = "${var.aws_instance["instance_count"]}"
  launch_configuration = "${aws_launch_configuration.as_conf.id}"
  health_check_type = "EC2"
  health_check_grace_period = "120"
  default_cooldown = "30"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    app_name = "${var.tag_app_name}"
    app_env = "${var.tag_app_env}"
  }
}
