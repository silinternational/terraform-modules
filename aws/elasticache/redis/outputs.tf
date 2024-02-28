/*
 * Cluster outputs
 */
output "cache_nodes" {
  value = aws_elasticache_cluster.redis.cache_nodes
}

output "configuration_endpoint" {
  value = aws_elasticache_cluster.redis.configuration_endpoint
}

output "cluster_address" {
  value = aws_elasticache_cluster.redis.cache_nodes[0].address
}

