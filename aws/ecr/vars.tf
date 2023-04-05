variable "repo_name" {
  type = string
}

variable "ecsServiceRole_arn" {
  type = string
}

variable "ecsInstanceRole_arn" {
  type = string
}

variable "cd_user_arn" {
  type = string
}

variable "repository_lifecycle_policy" {
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
