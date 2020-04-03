/*
 * Required variables
 */
variable "app_name" {
  type = string
}

variable "app_env" {
  type = string
}

variable "aws_zones" {
  type = list(string)
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

