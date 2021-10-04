resource "kubernetes_namespace" "ingress-nginx" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "ingress-nginx"
    }
  }
}
