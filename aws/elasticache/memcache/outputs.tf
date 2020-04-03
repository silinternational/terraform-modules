/*
 * Cluster outputs
 */
output "cache_nodes" {
  value = [aws_elasticache_cluster.memcache.cache_nodes]
}

output "configuration_endpoint" {
  value = aws_elasticache_cluster.memcache.configuration_endpoint
}

output "cluster_address" {
  value = aws_elasticache_cluster.memcache.cluster_address
}

