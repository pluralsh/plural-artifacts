resource "kubernetes_namespace" "keycloak" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "keycloak"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}

