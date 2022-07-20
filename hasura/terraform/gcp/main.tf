resource "kubernetes_namespace" "hasura" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "hasura"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}
