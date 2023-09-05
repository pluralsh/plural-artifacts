resource "kubernetes_namespace" "cert_manager" {
  count = var.create_namespace ? 1 : 0
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "cert-manager"

    }
  }
}
