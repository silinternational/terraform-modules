resource "aws_db_instance" "db_instance" {
  engine = "${var.engine}"
  engine_version = "${var.engine_version}"
  allocated_storage = "${var.allocated_storage}"
  instance_class = "${var.instance_class}"
  name = "${var.db_name}"
  identifier = "${var.app_name}-${var.app_env}"
  username = "${var.db_root_user}"
  password = "${var.db_root_pass}"
  db_subnet_group_name = "${var.subnet_group_name}"
  storage_type = "${var.storage_type}"
  availability_zone = "${var.availability_zone}"
  backup_retention_period = "${var.backup_retention_period}"
  multi_az = "${var.multi_az}"
  publicly_accessible = false
  vpc_security_group_ids = ["${var.security_groups}"]
  skip_final_snapshot = "${var.skip_final_snapshot}"
  tags {
    Name = "${var.app_name}-${var.app_env}"
    app_name = "${var.app_name}"
    app_env = "${var.app_env}"
  }
}
