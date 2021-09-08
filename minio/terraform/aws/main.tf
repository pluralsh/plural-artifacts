resource "kubernetes_namespace" "minio" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "minio"
    }
  }
}
