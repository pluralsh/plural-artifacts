resource "kubernetes_namespace" "descheduler" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "descheduler"

    }
  }
}

