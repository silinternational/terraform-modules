resource "aws_db_instance" "db_instance" {
  engine                  = var.engine
  engine_version          = var.engine_version
  allocated_storage       = var.allocated_storage
  copy_tags_to_snapshot   = var.copy_tags_to_snapshot
  instance_class          = var.instance_class
  name                    = var.db_name
  identifier              = "${var.app_name}-${var.app_env}"
  username                = var.db_root_user
  password                = var.db_root_pass
  db_subnet_group_name    = var.subnet_group_name
  storage_type            = var.storage_type
  storage_encrypted       = var.storage_encrypted
  kms_key_id              = var.kms_key_id
  availability_zone       = var.multi_az == "true" ? "" : var.availability_zone
  backup_retention_period = var.backup_retention_period
  multi_az                = var.multi_az
  publicly_accessible     = var.publicly_accessible
  vpc_security_group_ids  = var.security_groups
  skip_final_snapshot     = var.skip_final_snapshot
  parameter_group_name    = var.parameter_group_name
  deletion_protection     = var.deletion_protection

  tags = merge({
    Name     = "${var.app_name}-${var.app_env}"
    app_name = var.app_name
    app_env  = var.app_env
  }, var.tags)
}

