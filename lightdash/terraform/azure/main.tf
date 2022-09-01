resource "kubernetes_namespace" "lightdash" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "lightdash"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}

