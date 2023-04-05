resource "kubernetes_namespace" "mimir" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "mimir"

    }
  }
}

