resource "kubernetes_namespace" "metabase" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "metabase"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}
