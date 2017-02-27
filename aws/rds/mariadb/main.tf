resource "aws_db_instance" "db_instance" {
  engine = "${var.engine}"
  engine_version = "${var.engine_version}"
  allocated_storage = "${var.allocated_storage}"
  instance_class = "${var.instance_class}"
  name = "${var.db_name}"
  identifier = "${var.tag_app_name}-${var.tag_app_env}"
  username = "${var.db_root_user}"
  password = "${var.db_root_pass}"
  db_subnet_group_name = "${var.subnet_group_name}"
  storage_type = "${var.storage_type}"
  availability_zone = "${var.availability_zone}"
  backup_retention_period = "${var.backup_retention_period}"
  multi_az = "${var.multi_az}"
  publicly_accessible = false
  vpc_security_group_ids = ["${var.security_groups}"]
  tags {
    Name = "${var.tag_app_name}-${var.tag_app_env}"
    app_name = "${var.tag_app_name}"
    app_env = "${var.tag_app_env}"
  }
}

/*
 * Create separate app user with limited access
 * mysql provider currently broke, see: https://github.com/hashicorp/terraform/issues/11799
 */
 /*provider "mysql" {
    endpoint = "${aws_db_instance.db_instance.endpoint}"
    username = "${aws_db_instance.db_instance.username}"
    password = "${aws_db_instance.db_instance.password}"
 }

resource "mysql_user" "appuser" {
  user = "${var.db_app_user}"
  password = "${var.db_app_pass}"
  host = "%"
  depends_on = ["aws_db_instance.db_instance"]
}

resource "mysql_grant" "appusergrant" {
  user = "${mysql_user.appuser.user}"
  host = "%"
  database = "${var.db_name}"
  privileges = [
    "SELECT", "INSERT", "UPDATE", "DELETE", "CREATE", "DROP",
    "INDEX", "ALTER", "CREATE TEMPORARY TABLES", "LOCK TABLES"
  ]
}*/
