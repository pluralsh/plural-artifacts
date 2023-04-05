resource "kubernetes_namespace" "trace-shield" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "trace-shield"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}
