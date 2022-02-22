/*
 * Required variables
 */
variable "app_name" {
  type = string
}

variable "app_env" {
  type = string
}

/*
 * Optional variables
 */
variable "amiFilter" {
  type    = string
  default = "amzn2-ami-ecs-hvm-*-x86_64-ebs"
}

variable "ecsInstanceRoleAssumeRolePolicy" {
  type = string

  default = jsonencode(
    {
      Version = "2008-10-17"
      Statement = [
        {
          Sid    = ""
          Effect = "Allow"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        },
      ]
  })
}

variable "ecsInstancerolePolicy" {
  type = string

  default = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "ecs:CreateCluster",
            "ecs:DeregisterContainerInstance",
            "ecs:DiscoverPollEndpoint",
            "ecs:Poll",
            "ecs:RegisterContainerInstance",
            "ecs:StartTelemetrySession",
            "ecs:Submit*",
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
          ]
          Resource = "*"
        }
      ]
  })
}

variable "ecsServiceRoleAssumeRolePolicy" {
  type = string

  default = jsonencode(
    {
      Version = "2008-10-17"
      Statement = [
        {
          Sid    = ""
          Effect = "Allow"
          Principal = {
            Service = "ecs.amazonaws.com"
          }
          Action = "sts:AssumeRole"
        },
      ]
  })
}

variable "ecsServiceRolePolicy" {
  default = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:Describe*",
            "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
            "elasticloadbalancing:DeregisterTargets",
            "elasticloadbalancing:Describe*",
            "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
            "elasticloadbalancing:RegisterTargets"
          ]
          Resource = "*"
        },
      ]
  })
}

