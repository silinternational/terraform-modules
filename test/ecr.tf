module "simple" {
  source              = "../aws/ecr"
  repo_name           = "test"
  ecsInstanceRole_arn = "arn:aws:iam::123456789012:role/instance-role"
  ecsServiceRole_arn  = "arn:aws:iam::123456789012:role/service-role"
  cd_user_arn         = "arn:aws:iam::123456789012:user/cd-user"
}
