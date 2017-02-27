/*
 * Required variables
 */
 variable "tag_app_name" {
   type = "string"
 }
 variable "tag_app_env" {
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
  type = "string"
  default = "80"
}
variable "protocol" {
  type = "string"
  default = "HTTP"
}
variable "access_logs_enabled" {
  type = "string"
  default = "false"
}
variable "access_logs_bucket" {
  type = "string"
  default = ""
}
variable "ssl_policy" {
  type = "string"
  default = "ELBSecurityPolicy-2015-05"
}
variable "enable_https" {
  type = "string"
  default = true
}
variable "enable_http" {
  type = "string"
  default = false
}
