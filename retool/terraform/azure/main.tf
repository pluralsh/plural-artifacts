resource "kubernetes_namespace" "retool" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "retool"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}

