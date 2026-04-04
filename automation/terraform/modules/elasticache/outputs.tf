output "primary_endpoint" {
  value = aws_elasticache_replication_group.redis.primary_endpoint_address
}

output "reader_endpoint" {
  value = aws_elasticache_replication_group.redis.reader_endpoint_address
}

output "port" {
  value = aws_elasticache_replication_group.redis.port
}

output "auth_token_secret_arn" {
  value = aws_secretsmanager_secret.redis_auth.arn
}
