resource "kubernetes_namespace" "directus" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by"   = "plural"
      "app.plural.sh/name"             = "directus"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}

