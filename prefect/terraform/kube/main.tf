resource "kubernetes_namespace" "prefect" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "prefect"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}
