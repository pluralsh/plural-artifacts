resource "helm_release" "ccm" {
  name       = "cloud-provider-equinix-metal"
  namespace = var.namespace

  repository = "https://pluralsh.github.io/plural-helm-charts"
  chart      = "cloud-provider-equinix-metal"

  set {
    name  = "image.tag"
    value = var.ccm_version
  }

  set {
    name  = "config.apiKey"
    value = var.auth_token
  }

  set {
    name  = "config.projectID"
    value = var.project_id
  }

  set {
    name  = "config.loadbalancer"
    value = "kube-vip://"
  }

  depends_on = [
    rke_cluster.cluster,
    kubernetes_namespace.bootstrap
  ]
}
