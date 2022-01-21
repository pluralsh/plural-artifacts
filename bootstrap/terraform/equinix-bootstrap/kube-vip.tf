resource "helm_release" "kube_vip_control_plane" {
  name       = "kube-vip-control-plane"
  namespace = var.namespace

  repository = "https://pluralsh.github.io/plural-helm-charts"
  chart      = "kube-vip"
  version    = "0.4.3"

  set {
    name  = "image.tag"
    value = var.kube_vip_version
  }

  set {
    name  = "fullnameOverride"
    value = "kube-vip-control-plane"
  }

  set {
    name  = "serviceAccount.name"
    value = "kube-vip-control-plane"
  }

  set {
    name  = "env.vip_interface"
    value = "lo"
  }

  set {
    name  = "env.vip_arp"
    type = "string"
    value = "false"
  }

  set {
    name  = "env.lb_enable"
    type = "string"
    value = "false"
  }

  set {
    name  = "env.lb_port"
    type = "string"
    value = "6443"
  }

  set {
    name  = "env.vip_cidr"
    type = "string"
    value = "32"
  }

  set {
    name  = "env.cp_enable"
    type = "string"
    value = "true"
  }

  set {
    name  = "env.svc_enable"
    type = "string"
    value = "false"
  }

set {
    name  = "env.vip_leaderelection"
    type = "string"
    value = "true"
  }

  set {
    name  = "env.cp_namespace"
    value = "${var.namespace}"
  }

  set {
    name  = "config.address"
    value = "${metal_reserved_ip_block.api_server.network}"
  }

  set {
    name  = "env.annotation"
    value = "metal.equinix.com"
  }

  set {
    name  = "env.bgp_enable"
    type = "string"
    value = "true"
  }

  set {
    name  = "env.bgp_routerid"
    value = ""
  }

  set {
    name  = "env.bgp_as"
    type = "string"
    value = "65000"
  }

  set {
    name  = "env.bgp_peeraddress"
    value = ""
  }

  set {
    name  = "env.bgp_peerpass"
    value = ""
  }

  set {
    name  = "env.bgp_peeras"
    type = "string"
    value = "65000"
  }

  set {
    name  = "affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key"
    value = "node-role.kubernetes.io/master"
  }

  set {
    name  = "affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator"
    value = "Exists"
  }

  set {
    name  = "affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[1].matchExpressions[0].key"
    value = "node-role.kubernetes.io/controlplane"
  }

  set {
    name  = "affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[1].matchExpressions[0].operator"
    value = "Exists"
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
    kubernetes_namespace.bootstrap
  ]
}

resource "helm_release" "kube_vip_services" {
  name       = "kube-vip-services"
  namespace = var.namespace

  repository = "https://pluralsh.github.io/plural-helm-charts"
  chart      = "kube-vip"
  version    = "0.4.3"

  set {
    name  = "image.tag"
    value = var.kube_vip_version
  }

  set {
    name  = "fullnameOverride"
    value = "kube-vip-services"
  }

  set {
    name  = "serviceAccount.name"
    value = "kube-vip-services"
  }

  set {
    name  = "env.vip_interface"
    value = "lo"
  }

  set {
    name  = "env.vip_arp"
    type = "string"
    value = "false"
  }

  set {
    name  = "env.lb_enable"
    type = "string"
    value = "false"
  }

  set {
    name  = "env.lb_port"
    type = "string"
    value = "6443"
  }

  set {
    name  = "env.vip_cidr"
    type = "string"
    value = "32"
  }

  set {
    name  = "env.cp_enable"
    type = "string"
    value = "false"
  }

  set {
    name  = "env.svc_enable"
    type = "string"
    value = "true"
  }

set {
    name  = "env.vip_leaderelection"
    type = "string"
    value = "true"
  }

  set {
    name  = "env.cp_namespace"
    value = "${var.namespace}"
  }

  set {
    name  = "env.annotation"
    value = "metal.equinix.com"
  }

  set {
    name  = "env.bgp_enable"
    type = "string"
    value = "true"
  }

  set {
    name  = "env.bgp_routerid"
    value = ""
  }

  set {
    name  = "env.bgp_as"
    type = "string"
    value = "65000"
  }

  set {
    name  = "env.bgp_peeraddress"
    value = ""
  }

  set {
    name  = "env.bgp_peerpass"
    value = ""
  }

  set {
    name  = "env.bgp_peeras"
    type = "string"
    value = "65000"
  }

  set {
    name  = "affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].key"
    value = "node-role.kubernetes.io/worker"
  }

  set {
    name  = "affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms[0].matchExpressions[0].operator"
    value = "Exists"
  }

  depends_on = [
    rke_cluster.cluster,
    kubernetes_namespace.bootstrap
  ]
}

locals {
  orig_kube_config = yamldecode(rke_cluster.cluster.kube_config_yaml)
  kube_config = {
    apiVersion = local.orig_kube_config.apiVersion
    kind = local.orig_kube_config.kind
    contexts = local.orig_kube_config.contexts
    users = local.orig_kube_config.users
    current-context = local.orig_kube_config.contexts[0].name
    clusters = [
      {
        name = local.orig_kube_config.clusters[0].name
        cluster = {
          api-version = local.orig_kube_config.clusters[0].cluster.api-version
          certificate-authority-data = local.orig_kube_config.clusters[0].cluster.certificate-authority-data
          server = "https://${metal_reserved_ip_block.api_server.network}:6443"
        }
      }
    ]
  }
  depends_on = [
    rke_cluster.cluster
  ]
}

resource "local_file" "kube_cluster_yaml" {
  filename = "${path.root}/kube_config_cluster.yaml"
  content  = replace(yamlencode(local.kube_config), "/((?:^|\n)[\\s-]*)\"([\\w-]+)\":/", "$1$2:")
  depends_on = [
    local.orig_kube_config,
    local.kube_config,
    rke_cluster.cluster
  ]
}

# wait for kube-vip for the control plane to available
resource "time_sleep" "wait_120_seconds_after_deploy" {
  create_duration = "120s"
  depends_on = [
    helm_release.kube_vip_control_plane,
    helm_release.kube_vip_services,
    helm_release.ccm,
  ]
}
