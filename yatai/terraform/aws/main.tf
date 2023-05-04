resource "kubernetes_namespace" "yatai" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "yatai"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}
