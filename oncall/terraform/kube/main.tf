resource "kubernetes_namespace" "oncall" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "oncall"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}

data "kubernetes_secret" "rabbitmq" {
  metadata {
    name = var.rabbitmq_secret
    namespace = var.rabbitmq_namespace
  }
}
