resource "kubernetes_namespace" "vaultwarden" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "vaultwarden"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}
