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

variable "ami_id" {
  type = string
}

variable "associate_public_ip_address" {
  type    = bool
  default = false
}

variable "aws_instance" {
  type = map(string)

  default = {
    instance_type  = "t2.micro"
    volume_size    = "8"
    instance_count = "3"
  }
}

variable "cpu_credits" {
  description = "One of 'standard', 'unlimited'"
  type        = string
  default     = ""
}

variable "root_device_name" {
  type    = string
  default = "/dev/xvda"
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "default_sg_id" {
  type = string
}

variable "ecs_instance_profile_id" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "key_name" {
  type    = string
  default = ""
}

variable "additional_security_groups" {
  type        = list(string)
  description = "A list of additional security groups to place instances into"
  default     = []
}

variable "additional_user_data" {
  type        = string
  description = "Shell command to append to the EC2 user_data"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to be added to all resources, including the network-interface and volume created by the launch template"
  default     = {}
}

variable "enable_ipv6" {
  description = "set to true to add an IPv6 IP address to ASG-created instances"
  type        = bool
  default     = false
}
