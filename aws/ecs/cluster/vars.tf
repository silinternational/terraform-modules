/*
 * Required variables
 */
variable "app_name" {
  description = "The name of the app. Used to create the ECS cluster name. Required if `cluster_name` is not specified."
  type        = string
  default     = ""
}

variable "app_env" {
  description = "The environment of the app, e.g. \"prod\". Used to create the ECS cluster name."
  type        = string
  default     = ""
}

/*
 * Optional variables
 */

variable "amiFilter" {
  description = "A filter to limit which Amazon Machine Images (AMI) to include in the `ami_id` output."
  type        = string
  default     = "amzn2-ami-ecs-hvm-*-x86_64-ebs"
}

variable "cluster_name" {
  description = "Name of the ECS cluster - if blank, the cluster name will be \"app_name-app_env\" - if not blank, app_name and app_env are not required"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Map of tags to add to the ECS service. Duplicate tags will be overridden."
  type        = map(any)
  default     = {}
}
