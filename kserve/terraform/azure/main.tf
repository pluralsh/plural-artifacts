resource "kubernetes_namespace" "kserve" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "kserve"

    }
  }
}

