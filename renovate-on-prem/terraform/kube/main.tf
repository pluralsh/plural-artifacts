resource "kubernetes_namespace" "renovate-on-prem" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "renovate-on-prem"

    }
  }
}

