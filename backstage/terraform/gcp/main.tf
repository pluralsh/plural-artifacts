resource "kubernetes_namespace" "backstage" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "backstage"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}

