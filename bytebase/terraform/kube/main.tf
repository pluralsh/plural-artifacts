resource "kubernetes_namespace" "bytebase" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "bytebase"

    }
  }
}

