resource "helm_release" "ccm" {
  name       = "cloud-provider-equinix-metal"
  namespace = var.namespace

  repository = "https://pluralsh.github.io/plural-helm-charts"
  chart      = "cloud-provider-equinix-metal"
  version    = "0.1.4"

  set {
    name = "image.repository"
    value = "gcr.io/pluralsh/equinix/cloud-provider-equinix-metal"
  }

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

  set {
    name  = "tolerations[0].effect"
    value = "NoSchedule"
  }

  # set {
  #   name  = "tolerations[0].key"
  #   value = "node-role.kubernetes.io/controlplane"
  # }

  set {
    name  = "tolerations[0].operator"
    value = "Exists"
  }

  set {
    name  = "tolerations[1].effect"
    value = "NoExecute"
  }

  # set {
  #   name  = "tolerations[1].key"
  #   value = "node-role.kubernetes.io/etcd"
  # }

  set {
    name  = "tolerations[1].operator"
    value = "Exists"
  }

  depends_on = [
    rke_cluster.cluster,
    kubernetes_namespace.bootstrap,
  ]
}
