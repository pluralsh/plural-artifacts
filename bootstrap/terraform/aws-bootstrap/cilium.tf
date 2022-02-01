resource "kubectl_manifest" "service_monitor_crd"{
  yaml_body = file("${path.module}/templates/monitoring.coreos.com_servicemonitors.yaml")

  depends_on = [
    module.cluster.cluster_id
  ]
}

resource "helm_release" "cilium" {
  name       = "cilium"
  namespace = "kube-system"

  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.11.1"

  set {
    name  = "cluster.name"
    value = var.cluster_name
  }

  set {
    name  = "containerRuntime.integration"
    value = "auto"
  }

  # AWS related configs
  set {
    name  = "eni.enabled"
    value = "true"
  }

  set {
    name  = "eni.awsReleaseExcessIPs"
    value = "true"
  }

  set {
    name  = "eni.updateEC2AdapterLimitViaAPI"
    value = "true"
  }

  set {
    name  = "ipam.mode"
    value = "eni"
  }

  set {
    name  = "egressMasqueradeInterfaces"
    value = "eth0"
  }

  set {
    name  = "tunnel"
    value = "disabled"
  }

  # kube-proxy related configs
  set {
    name  = "kubeProxyReplacement"
    value = "strict"
  }

  set {
    name  = "k8sServiceHost"
    value = trimprefix(module.cluster.cluster_endpoint, "https://")
  }

  set {
    name  = "k8sServicePort"
    value = 443
  }

  # Needed for Istio when using kube-proxy replacement
  set {
    name  = "hostServices.hostNamespaceOnly"
    value = "true"
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
    name  = "hubble.relay.enabled"
    value = "true"
  }

  set {
    name  = "hubble.ui.enabled"
    value = "true"
  }

  set {
    name  = "prometheus.enabled"
    value = "true"
  }

  set {
    name  = "prometheus.serviceMonitor.enabled"
    value = "false"
  }

  set {
    name  = "operator.prometheus.enabled"
    value = "true"
  }

  set {
    name  = "operator.prometheus.serviceMonitor.enabled"
    value = "true"
  }

  set {
    name  = "monitor.enabled"
    value = "true"
  }

  depends_on = [
    module.cluster.cluster_id,
    kubernetes_namespace.bootstrap,
    kubectl_manifest.service_monitor_crd,
  ]
}
