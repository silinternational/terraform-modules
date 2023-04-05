/*
 * Create ECR repository
 */
resource "aws_ecr_repository" "repo" {
  name = var.repo_name

  tags = merge({
    managed_by = "terraform"
    file       = path.module
    repository = "github.com/silinternational/terraform-modules"
    workspace  = path.workspace
  }, var.tags)
}

locals {
  repo_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Sid    = "ECS Pull Access"
        Effect = "Allow"
        Principal = {
          AWS = [
            var.ecsInstanceRole_arn,
            var.ecsServiceRole_arn,
          ]
        },
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
        ]
      },
      {
        Sid    = "CD push/pull"
        Effect = "Allow"
        Principal : {
          AWS : var.cd_user_arn
        },
        Action = [
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
        ]
      }
    ]
  })

  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep only image_retention_count images",
        selection = {
          tagStatus   = "tagged",
          countType   = "imageCountMoreThan",
          countNumber = var.image_retention_count,
        },
        action = {
          type = "expire",
        }
      },
    ]
  })
}

resource "aws_ecr_repository_policy" "policy" {
  repository = aws_ecr_repository.repo.name
  policy     = local.repo_policy
}

resource "aws_ecr_lifecycle_policy" "policy" {
  count = var.image_retention_count > 0 ? 1 : 0

  repository = aws_ecr_repository.repo
  policy     = local.lifecycle_policy
}
