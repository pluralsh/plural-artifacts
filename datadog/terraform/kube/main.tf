resource "kubernetes_namespace" "datadog" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "datadog"
    }
  }
}

