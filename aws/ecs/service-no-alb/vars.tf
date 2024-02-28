/*
 * Required Variables
 */
variable "cluster_id" {
  type = string
}

variable "service_name" {
  type = string
}

variable "service_env" {
  type = string
}

variable "container_def_json" {
  type = string
}

variable "desired_count" {
  type = string
}

variable "volumes" {
  default     = []
  description = "A list of volume definitions in JSON format that containers in your task may use"
  type        = list(any)
}

/*
 * Optional Variables
 */
variable "task_role_arn" {
  type    = string
  default = ""
}

variable "network_mode" {
  type    = string
  default = "bridge"
}

variable "deployment_maximum_percent" {
  type    = string
  default = 200
}

variable "deployment_minimum_healthy_percent" {
  type    = string
  default = 50
}

