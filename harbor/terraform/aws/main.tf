resource "kubernetes_namespace" "harbor" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name"           = "harbor"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}
