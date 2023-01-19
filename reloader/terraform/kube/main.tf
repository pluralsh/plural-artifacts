resource "kubernetes_namespace" "reloader" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "reloader"

    }
  }
}

