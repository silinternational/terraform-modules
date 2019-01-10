/*
 * Required variables
 */
variable "app_name" {
  type    = "string"
  default = "terraform"
}

variable "app_env" {
  type    = "string"
  default = "testing"
}

variable "ami_id" {
  type = "string"
}

variable "associate_public_ip_address" {
  type    = "string"
  default = "false"
}

variable "aws_instance" {
  type = "map"

  default = {
    instance_type  = "t2.micro"
    volume_size    = "8"
    instance_count = "3"
  }
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

variable "key_name" {
  type    = "string"
  default = ""
}

variable "additional_security_groups" {
  type        = "list"
  description = "A list of additional security groups to place instances into"
  default     = []
}

variable "efs_dns_name" {
  type    = "string"
  default = ""
}

variable "mount_point" {
  type    = "string"
  default = ""
}
