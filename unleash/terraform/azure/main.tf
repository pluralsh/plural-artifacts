resource "kubernetes_namespace" "unleash" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "unleash"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}

