/*
 * Required variables
 */
variable "app_name" {
  type    = string
  default = "terraform"
}

variable "app_env" {
  type    = string
  default = "testing"
}

variable "aws_zones" {
  type = list(string)

  default = [
    "us-east-1c",
    "us-east-1d",
    "us-east-1e",
  ]
}

variable "enable_dns_hostnames" {
  type    = bool
  default = false
}

variable "create_nat_gateway" {
  description = "Set to false to remove NAT gateway and associated route"
  type        = bool
  default     = true
}

variable "vpc_cidr_block" {
  description = "The block of IP addresses (as a CIDR) the VPC should use"
  type        = string
  default     = "10.0.0.0/16"
}
