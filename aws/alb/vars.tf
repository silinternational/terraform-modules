/*
 * Required variables
 */
variable "app_name" {
  type = "string"
}

variable "app_env" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "security_groups" {
  type = "list"
}

variable "subnets" {
  type = "list"
}

variable "certificate_arn" {
  type = "string"
}

/*
 * Optional variables
 */
variable "port" {
  type    = "string"
  default = 80
}

variable "protocol" {
  type    = "string"
  default = "HTTP"
}

variable "access_logs_enabled" {
  type    = "string"
  default = "false"
}

variable "access_logs_bucket" {
  type    = "string"
  default = ""
}

variable "alb_name" {
  type    = "string"
  default = ""
  description = "Manual override for ALB name (which is otherwise assembled from other given data)"
}

variable "internal" {
  type    = "string"
  default = "false"
}

variable "ssl_policy" {
  type    = "string"
  default = "ELBSecurityPolicy-2015-05"
}
