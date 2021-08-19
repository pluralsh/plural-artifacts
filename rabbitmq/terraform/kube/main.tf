resource "kubernetes_namespace" "rabbitmq" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
    }
  }
}