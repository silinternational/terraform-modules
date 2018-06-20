/*
 * Required variables
 */
variable "app_name" {
  type = "string"
}

variable "app_env" {
  type = "string"
}

variable "aws_zones" {
  type = "list"

  default = [
    "us-east-1c",
    "us-east-1d",
    "us-east-1e",
  ]
}

variable "enable_dns_hostnames" {
  type    = "string"
  default = "true"
}
