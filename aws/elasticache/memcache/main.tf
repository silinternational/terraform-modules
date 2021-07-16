/*
 * Create Elasticache subnet group
 */
resource "aws_elasticache_subnet_group" "memcache_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = var.subnet_ids
}

/*
 * Create Cluster
 */
resource "aws_elasticache_cluster" "memcache" {
  cluster_id           = replace(var.cluster_id, "/(.{0,20})(.*)/", "$1") // truncates to maximum of 20 characters
  engine               = "memcached"
  node_type            = var.node_type
  port                 = var.port
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = var.parameter_group_name
  security_group_ids   = var.security_group_ids
  subnet_group_name    = aws_elasticache_subnet_group.memcache_subnet_group.name
  az_mode              = var.az_mode

  tags = {
    app_name = var.app_name
    app_env  = var.app_env
  }
}
