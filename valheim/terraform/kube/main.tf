resource "kubernetes_namespace" "valheim" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "valheim"

    }
  }
}

