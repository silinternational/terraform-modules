/*
 * Required variables
 */
variable "app_name" {
  type = string
}

variable "app_env" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_root_user" {
  type = string
}

variable "db_root_pass" {
  type = string
}

variable "subnet_group_name" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

/*
 * Optional variables
 */

variable "apply_immediately" {
  description = "Apply database modifications immediately, rather than during the next maintenance window. CAUTION: may cause downtime!"
  type        = bool
  default     = false
}

variable "availability_zone" {
  type    = string
  default = ""
}

variable "ca_cert_identifier" {
  description = "The identifier of the CA certificate for the DB instance."
  type        = string
  default     = null
}

variable "copy_tags_to_snapshot" {
  type    = bool
  default = true
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "engine" {
  type    = string
  default = "mariadb"
}

variable "engine_version" {
  type    = string
  default = ""
}

variable "allocated_storage" {
  type    = string
  default = "8"
}

variable "storage_type" {
  type    = string
  default = "gp2"
}

variable "storage_encrypted" {
  type    = bool
  default = false
}

variable "kms_key_id" {
  type    = string
  default = ""
}

variable "instance_class" {
  type    = string
  default = "db.t2.micro"
}

variable "backup_retention_period" {
  type    = string
  default = "14"
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "parameter_group_name" {
  type    = string
  default = ""
}

variable "tags" {
  type        = map(any)
  description = "Map of tags to add to the rds instance. Duplicate tags will be overridden."
  default     = {}
}

variable "replicate_source_db" {
  type        = string
  description = "To create a replica DB, specify the source database"
  default     = null
}

variable "replica_mode" {
  type        = string
  description = "Specifies whether the replica is in either \"mounted\" or \"open-read-only\" mode. This attribute is only supported by Oracle instances."
  default     = null
}
