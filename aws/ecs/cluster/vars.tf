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
