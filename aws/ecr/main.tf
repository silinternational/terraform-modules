/*
 * Create ECR repository
 */
resource "aws_ecr_repository" "repo" {
  name         = var.repo_name
  force_delete = var.force_delete
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

  /*
   This lifecycle policy expires images older than the `var.image_retention_count` newest images and not matched by
   any of the tags given in `var.image_retention_tags`. Each tag in `var.image_retention_tags` must be added as a
   separate rule because the list of tags within a rule must all be present on an image for it to match the rule.
 */
  lifecycle_policy = jsonencode({
    rules = concat(
      [
        for i, tag in var.image_retention_tags : {
          rulePriority = i + 1
          description  = "Keep specified images"
          selection = {
            tagStatus     = "tagged"
            tagPrefixList = [tag]
            countType     = "imageCountMoreThan"
            countNumber   = 1
          },
          action = {
            type = "expire"
          }
        }
      ],
      [
        {
          rulePriority = 1000,
          description  = "Keep only image_retention_count images"
          selection = {
            tagStatus   = "any"
            countType   = "imageCountMoreThan"
            countNumber = var.image_retention_count
          },
          action = {
            type = "expire"
          }
        }
      ]
    )
  })
}

resource "aws_ecr_repository_policy" "policy" {
  repository = aws_ecr_repository.repo.name
  policy     = local.repo_policy
}

resource "aws_ecr_lifecycle_policy" "policy" {
  count = var.image_retention_count > 0 ? 1 : 0

  repository = aws_ecr_repository.repo.name
  policy     = local.lifecycle_policy
}
