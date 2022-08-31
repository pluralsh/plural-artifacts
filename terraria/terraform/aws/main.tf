resource "kubernetes_namespace" "terraria" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "terraria"

    }
  }
}

