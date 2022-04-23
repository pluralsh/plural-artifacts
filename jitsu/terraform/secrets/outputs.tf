output "redis_password" {
  value = data.kubernetes_secret.redis.data.password
}