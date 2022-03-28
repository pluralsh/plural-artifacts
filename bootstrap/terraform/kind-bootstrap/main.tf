resource "kind_cluster" "cluster" {
    name            = var.cluster_name
    node_image      = "kindest/node:${var.kubernetes_version}"
    wait_for_ready  = true
    kubeconfig_path = "${path.root}/kube_config_cluster.yaml"

  kind_config {
      kind        = "Cluster"
      api_version = "kind.x-k8s.io/v1alpha4"

      node {
          role = "control-plane"
      }

      node {
          role = "worker"

          extra_port_mappings {
              container_port = 30080
              host_port      = 80
          }
          extra_port_mappings {
              container_port = 3443
              host_port      = 443
          }
      }
  }
}

resource "kubernetes_namespace" "bootstrap" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = var.namespace
    }
  }
  depends_on = [
    kind_cluster.cluster
  ]
}
