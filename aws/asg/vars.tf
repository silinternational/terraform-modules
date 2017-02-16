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
variable "ami_id" {
  type = "string"
}
variable "aws_instance" {
  type = "map"
  default = {
    instance_type = "t2.micro"
    volume_size = "8"
    instance_count = "3"
  }
}
variable "aws_zones" {
  type = "list"
  default = [
    "us-east-1c", "us-east-1d", "us-east-1e"
  ]
}

variable "private_subnet_ids" {
  type = "list"
}
variable "default_sg_id" {
  type = "string"
}
variable "ecs_instance_profile_id" {
  type = "string"
}
variable "ecs_cluster_name" {
  type = "string"
}
