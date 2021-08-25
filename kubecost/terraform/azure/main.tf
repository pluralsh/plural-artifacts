resource "kubernetes_namespace" "kubecost" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "kubecost"
    }
  }
}
