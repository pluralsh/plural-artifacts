resource "kubernetes_namespace" "hydra" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "hydra"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}

