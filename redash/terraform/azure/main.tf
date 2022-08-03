resource "kubernetes_namespace" "redash" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "redash"

    }
  }
}

