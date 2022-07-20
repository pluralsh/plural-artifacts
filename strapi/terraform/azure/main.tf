resource "kubernetes_namespace" "strapi" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "strapi"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}

