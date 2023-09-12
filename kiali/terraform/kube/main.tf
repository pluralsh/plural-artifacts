resource "kubernetes_namespace" "kiali" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "kiali"
      "istio-injection" = "enabled"
    }
  }
}
