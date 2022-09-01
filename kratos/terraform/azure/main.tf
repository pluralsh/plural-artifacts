resource "kubernetes_namespace" "kratos" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "kratos"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}

