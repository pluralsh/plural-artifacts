resource "kubernetes_namespace" "imgproxy" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "imgproxy"

    }
  }
}

