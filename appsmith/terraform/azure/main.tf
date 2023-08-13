resource "kubernetes_namespace" "appsmith" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "appsmith"

    }
  }
}

