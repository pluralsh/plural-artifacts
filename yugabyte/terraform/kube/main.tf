resource "kubernetes_namespace" "yugabyte" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "yugabyte"

    }
  }
}

