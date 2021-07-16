/*
 * Required Variables
 */
variable "cluster_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_group_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "app_name" {
  type = string
}

variable "app_env" {
  type = string
}

/*
 * Optional Variables
 */
variable "node_type" {
  type    = string
  default = "cache.t2.micro"
}

variable "port" {
  type    = string
  default = "6379"
}

variable "parameter_group_name" {
  type    = string
  default = "default.redis6.x"
}

variable "engine_version" {
  default = "6.x"
}
