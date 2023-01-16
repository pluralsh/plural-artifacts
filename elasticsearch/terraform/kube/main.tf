resource "kubernetes_namespace" "elasticsearch" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "elasticsearch"
      # "istio-injection" = "enabled"
    }
  }
}
