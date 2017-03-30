/*
 * Create separate app user with limited access
 * mysql provider currently broke, see: https://github.com/hashicorp/terraform/issues/11799
 */
 provider "mysql" {
    endpoint = "${var.endpoint}"
    username = "${var.username}"
    password = "${var.password}"
 }

resource "mysql_user" "appuser" {
  user = "${var.app_user}"
  password = "${var.app_pass}"
  host = "%"
}

resource "mysql_grant" "appusergrant" {
  user = "${mysql_user.appuser.user}"
  host = "%"
  database = "${var.database}"
  privileges = ["${var.privileges}"]
}
