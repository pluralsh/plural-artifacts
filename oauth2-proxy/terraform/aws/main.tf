resource "kubernetes_namespace" "oauth2-proxy" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "oauth2-proxy"
      "istio-injection" = "enabled"
    }
  }
}
