output "launch_template_id" {
  value = aws_launch_template.asg_lt.id
}

output "auto_scaling_group_id" {
  value = aws_autoscaling_group.asg.id
}

