data "kubernetes_secret" "redis" {
  metadata {
    name = var.redis_secret
    namespace = var.redis_namespace
  }
}