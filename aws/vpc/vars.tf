/*
 * Required variables
 */
variable "tag_app_name" {
  type = "string"
  default = "terraform"
}
variable "tag_app_env" {
  type = "string"
  default = "testing"
}
variable "aws_zones" {
  type = "list"
  default = [
    "us-east-1c", "us-east-1d", "us-east-1e"
  ]
}
