resource "kubernetes_namespace" "influx" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "influx"
    }
  }
}
