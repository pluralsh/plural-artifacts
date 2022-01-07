output "rabbitmq_password" {
  value = data.kubernetes_secret.rabbitmq.data.password
}

output "rabbitmq_username" {
  value = data.kubernetes_secret.rabbitmq.data.username
}

output "redis_password" {
  value = data.kubernetes_secret.redis.data.password
}