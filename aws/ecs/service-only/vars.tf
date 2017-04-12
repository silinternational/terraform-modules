/*
 * Required Variables
 */
variable "cluster_id" {
  type = "string"
}
variable "service_name" {
  type = "string"
}
variable "service_env" {
  type = "string"
}
variable "container_def_json" {
  type = "string"
}
variable "desired_count" {
  type = "string"
}
variable "lb_container_name" {
  type = "string"
}
variable "lb_container_port" {
  type = "string"
}
variable "tag_app_name" {
  type = "string"
}
variable "tag_app_env" {
  type = "string"
}
variable "vpc_id" {
  type = "string"
}
variable "security_groups" {
  type = "list"
}
variable "subnets" {
  type = "list"
}
variable "certificate_arn" {
  type = "string"
}

/*
 * Optional Variables
 */
 variable "port" {
   type = "string"
   default = 80
 }
 variable "protocol" {
   type = "string"
   default = "HTTP"
 }
 variable "access_logs_enabled" {
   type = "string"
   default = "false"
 }
 variable "access_logs_bucket" {
   type = "string"
   default = ""
 }
 variable "ssl_policy" {
   type = "string"
   default = "ELBSecurityPolicy-2015-05"
 }
 variable "enable_https" {
   type = "string"
   default = true
 }
 variable "enable_http" {
   type = "string"
   default = false
 }

variable "task_role_arn" {
  type = "string"
  default = ""
}
variable "network_mode" {
  type = "string"
  default = "bridge"
}
variable "deployment_maximum_percent" {
  type = "string"
  default = 200
}
variable "deployment_minimum_healthy_percent" {
  type = "string"
  default = 50
}


variable "ecsServiceRoleAssumeRolePolicy" {
  type = "string"
  default = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

variable "ecsServiceRolePolicy" {
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:DeregisterTargets",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:RegisterTargets"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
