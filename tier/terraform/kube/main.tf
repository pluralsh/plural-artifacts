resource "kubernetes_namespace" "tier" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "tier"

    }
  }
}

