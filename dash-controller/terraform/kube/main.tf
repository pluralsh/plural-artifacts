resource "kubernetes_namespace" "dash-controller" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "dash-controller"

    }
  }
}

