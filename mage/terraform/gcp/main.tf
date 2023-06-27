resource "kubernetes_namespace" "mage" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "mage"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}

