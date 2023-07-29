resource "kubernetes_namespace" "umami" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "umami"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}

