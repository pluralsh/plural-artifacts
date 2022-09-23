resource "kubernetes_namespace" "touca" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "touca"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}
