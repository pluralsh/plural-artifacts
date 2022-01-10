resource "kubernetes_namespace" "nocodb" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "nocodb"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}
