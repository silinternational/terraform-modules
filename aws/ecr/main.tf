/*
 * Create ECR repository
 */
resource "aws_ecr_repository" "repo" {
  name = var.repo_name
}

locals {
  repo_policy = templatefile("${path.module}/ecr-policy.json", {
    ecsInstanceRole_arn = var.ecsInstanceRole_arn
    ecsServiceRole_arn  = var.ecsServiceRole_arn
    cd_user_arn         = var.cd_user_arn
  })
}

resource "aws_ecr_repository_policy" "policy" {
  repository = aws_ecr_repository.repo.name
  policy     = local.repo_policy
}

