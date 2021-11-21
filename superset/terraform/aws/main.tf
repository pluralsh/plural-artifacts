resource "kubernetes_namespace" "superset" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "superset"
    }
  }
}
