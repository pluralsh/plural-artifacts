resource "kubernetes_namespace" "prefect-worker" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "prefect-worker"

    }
  }
}

