resource "kubernetes_namespace" "sftpgo" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "sftpgo"
    }
  }
}

