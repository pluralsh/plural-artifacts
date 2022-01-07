data "kubernetes_secret" "rabbitmq" {
  metadata {
    name = var.rabbitmq_secret
    namespace = var.rabbitmq_namespace
  }
}

data "kubernetes_secret" "redis" {
  metadata {
    name = var.redis_secret
    namespace = var.redis_namespace
  }
}