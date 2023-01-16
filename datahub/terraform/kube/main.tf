resource "kubernetes_namespace" "datahub" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "datahub"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}

