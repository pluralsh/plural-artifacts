resource "kubernetes_namespace" "grafana-tempo" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "grafana-tempo"
    }
  }
}
