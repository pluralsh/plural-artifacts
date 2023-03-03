resource "kubernetes_namespace" "posthog" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "posthog"

    }
  }
}

