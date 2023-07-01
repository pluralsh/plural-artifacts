resource "kubernetes_namespace" "cube" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "cube"

    }
  }
}

