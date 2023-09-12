resource "kubernetes_namespace" "istio-cni" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "istio-cni"

    }
  }
}

