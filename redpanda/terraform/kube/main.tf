resource "kubernetes_namespace" "redpanda" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name"           = "redpanda"
    }
  }
}
