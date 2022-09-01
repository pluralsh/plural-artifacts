resource "kubernetes_namespace" "lakefs" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "lakefs"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}

