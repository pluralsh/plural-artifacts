resource "kubernetes_namespace" "dremio" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "dremio"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}

