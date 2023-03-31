resource "kubernetes_namespace" "jupyterhub" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name"           = "jupyterhub"
    }
  }
}
