resource "helm_release" "cilium" {
  name       = "cilium"
  namespace = var.namespace

  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.11.0"

  set {
    name  = "cluster.name"
    value = var.cluster_name
  }

  set {
    name  = "containerRuntime.integration"
    value = "auto"
  }

  set {
    name  = "hubble.listenAddress"
    value = ":4244"
  }

  set {
    name  = "hubble.metrics.enabled"
    value = "{dns:query;ignoreAAAA,drop,tcp,flow,icmp,http}"
  }

  set {
    name  = "hubble.metrics.serviceMonitor.enabled"
    value = "true"
  }

  set {
    name  = "hubble.metrics.serviceMonitor.enabled"
    value = "true"
  }

  set {
    name  = "hubble.relay.enabled"
    value = "true"
  }

  set {
    name  = "hubble.ui.enabled"
    value = "true"
  }

  # set {
  #   name  = "hubble.ui.ingress.enabled"
  #   value = "true"
  # }

  # set {
  #   name  = "hubble.ui.ingress.hosts"
  #   value = "true"
  # }

  set {
    name  = "prometheus.enabled"
    value = "true"
  }

  set {
    name  = "prometheus.serviceMonitor.enabled"
    value = "true"
  }

  # set {
  #   name  = "monitor.enabled"?
  #   value = "true"
  # }

  depends_on = [
    rke_cluster.cluster,
    kubernetes_namespace.bootstrap
  ]
}
