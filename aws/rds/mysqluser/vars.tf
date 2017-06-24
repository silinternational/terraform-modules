/*
 * Required variables
 */
variable "endpoint" {
  type = "string"
}

variable "username" {
  type = "string"
}

variable "password" {
  type = "string"
}

variable "app_user" {
  type = "string"
}

variable "app_pass" {
  type = "string"
}

variable "database" {
  type = "string"
}

/*
 * Optional variables
 */
variable "create_database" {
  type    = "string"
  default = false
}

variable "privileges" {
  type = "list"

  default = [
    "SELECT",
    "INSERT",
    "UPDATE",
    "DELETE",
    "CREATE",
    "DROP",
    "INDEX",
    "ALTER",
    "CREATE TEMPORARY TABLES",
    "LOCK TABLES",
  ]
}
