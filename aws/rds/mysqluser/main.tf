/*
 * Create separate app user with limited access
 * mysql provider currently broke, see: https://github.com/hashicorp/terraform/issues/11799
 */
provider "mysql" {
  endpoint = "${var.endpoint}"
  username = "${var.username}"
  password = "${var.password}"
}

resource "mysql_database" "appdb" {
  count                 = "${var.create_database}"
  name                  = "${var.database}"
  default_character_set = "utf8"
  default_collation     = "utf8_general_ci"
}

resource "mysql_user" "appuser" {
  user     = "${var.app_user}"
  password = "${var.app_pass}"
  host     = "%"
}

resource "mysql_grant" "appusergrant" {
  user       = "${var.app_user}"
  host       = "%"
  database   = "${var.database}"
  privileges = ["${var.privileges}"]
  depends_on = ["mysql_user.appuser"]
}
