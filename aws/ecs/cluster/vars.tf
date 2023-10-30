/*
 * Required variables
 */
variable "app_name" {
  type    = string
  default = ""
}

variable "app_env" {
  type    = string
  default = ""
}

/*
 * Optional variables
 */

variable "amiFilter" {
  type    = string
  default = "amzn2-ami-ecs-hvm-*-x86_64-ebs"
}

variable "cluster_name" {
  description = "name of the ECS cluster - if blank, the cluster name will be \"app_name-app_env\" - if not blank, app_name and app_env are not required"
  default     = ""
}

variable "tags" {
  type        = map(any)
  description = "Map of tags to add to the ECS service. Duplicate tags will be overridden."
  default     = {}
}
