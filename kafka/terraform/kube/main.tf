resource "kubernetes_namespace" "kafka" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "kafka"
    }
  }
}
