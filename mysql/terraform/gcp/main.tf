resource "kubernetes_namespace" "mysql" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "mysql"
    }
  }
}
