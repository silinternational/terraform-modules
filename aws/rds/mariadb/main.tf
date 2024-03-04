resource "aws_db_instance" "db_instance" {
  apply_immediately       = var.apply_immediately
  engine                  = var.engine
  engine_version          = var.engine_version
  allocated_storage       = var.allocated_storage
  copy_tags_to_snapshot   = var.copy_tags_to_snapshot
  ca_cert_identifier      = var.ca_cert_identifier
  instance_class          = var.instance_class
  db_name                 = var.replicate_source_db == null ? var.db_name : null
  identifier              = "${var.app_name}-${var.app_env}"
  username                = var.replicate_source_db == null ? var.db_root_user : null
  password                = var.replicate_source_db == null ? var.db_root_pass : null
  db_subnet_group_name    = var.subnet_group_name
  storage_type            = var.storage_type
  storage_encrypted       = var.storage_encrypted
  kms_key_id              = var.kms_key_id
  availability_zone       = var.multi_az ? "" : var.availability_zone
  backup_retention_period = var.backup_retention_period
  multi_az                = var.multi_az
  publicly_accessible     = var.publicly_accessible
  vpc_security_group_ids  = var.security_groups
  skip_final_snapshot     = var.skip_final_snapshot
  parameter_group_name    = var.parameter_group_name
  deletion_protection     = var.deletion_protection
  replicate_source_db     = var.replicate_source_db
  replica_mode            = var.replica_mode

  tags = merge({
    Name     = "${var.app_name}-${var.app_env}"
    app_name = var.app_name
    app_env  = var.app_env
  }, var.tags)
}
