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

variable "force_delete" {
  description = "When deleting this ECR repository, whether to proceed even if it contains images."
  type        = bool
  default     = null
}

variable "image_retention_count" {
  default = 0
}

variable "image_retention_tags" {
  type    = list(string)
  default = ["latest"]
}
