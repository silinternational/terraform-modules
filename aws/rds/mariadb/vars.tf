/*
 * Required variables
 */
variable "tag_app_name" {
  type = "string"
}
variable "tag_app_env" {
   type = "string"
}
variable "db_name" {
  type = "string"
}
variable "db_root_user" {
  type = "string"
}
variable "db_root_pass" {
  type = "string"
}
variable "subnet_group_name" {
  type = "string"
}
variable "availability_zone" {
  type = "string"
}
variable "security_groups" {
  type = "list"
}

/*
 * Optional variables
 */
variable "engine" {
  type = "string"
  default = "mariadb"
}
variable "engine_version" {
  type = "string"
  default = ""
}
variable "allocated_storage" {
  type = "string"
  default = "8"
}
variable "storage_type" {
  type = "string"
  default = "gp2"
}
variable "instance_class" {
  type = "string"
  default = "db.t2.micro"
}
variable "backup_retention_period" {
  type = "string"
  default = "14"
}
variable "multi_az" {
  type = "string"
  default = false
}
variable "skip_final_snapshot" {
  type = "string"
  default = true
}
