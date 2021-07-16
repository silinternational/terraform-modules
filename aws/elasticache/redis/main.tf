/*
 * Create Elasticache subnet group
 */
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
}

/*
 * Create Cluster
 */
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = replace(var.cluster_id, "/(.{0,20})(.*)/", "$1") // truncates to maximum of 20 characters
  engine               = "redis"
  engine_version       = var.engine_version
  node_type            = var.node_type
  port                 = var.port
  num_cache_nodes      = "1"
  parameter_group_name = var.parameter_group_name
  security_group_ids   = var.security_group_ids
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name

  tags = {
    app_name = var.app_name
    app_env  = var.app_env
  }
}
