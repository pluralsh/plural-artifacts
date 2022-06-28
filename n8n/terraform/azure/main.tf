resource "kubernetes_namespace" "n8n" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "n8n"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}

