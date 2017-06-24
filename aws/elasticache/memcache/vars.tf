/*
 * Required Variables
 */
variable "cluster_id" {
  type = "string"
}

variable "security_group_ids" {
  type = "list"
}

variable "subnet_group_name" {
  type = "string"
}

variable "subnet_ids" {
  type = "list"
}

variable "availability_zones" {
  type = "list"
}

variable "app_name" {
  type = "string"
}

variable "app_env" {
  type = "string"
}

/*
 * Optional Variables
 */
variable "node_type" {
  type    = "string"
  default = "cache.t2.micro"
}

variable "port" {
  type    = "string"
  default = "11211"
}

variable "num_cache_nodes" {
  type    = "string"
  default = 2
}

variable "parameter_group_name" {
  type    = "string"
  default = "default.memcached1.4"
}

variable "az_mode" {
  type    = "string"
  default = "cross-az"
}
