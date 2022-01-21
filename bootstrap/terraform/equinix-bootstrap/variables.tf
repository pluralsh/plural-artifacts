variable "auth_token" {
  type        = string
  description = "Your Equinix Metal API key"
  sensitive   = true
}

# variable "facility" {
#   type        = string
#   description = "Equinix Metal Facility (conflicts with metro)"
#   default     = ""
# }

variable "metro" {
  type        = string
  description = "Equinix Metal Metro (conflicts with facility)"
  default     = "dc"
}

variable "project_id" {
  type        = string
  default     = "null"
  description = "Equinix Metal Project ID"
}

variable "control_plane_node_plan" {
  type        = string
  description = "K8s Primary Plan"
  default     = "c3.small.x86"
}

variable "worker_node_plan_x86" {
  type        = string
  description = "Plan for K8s x86 Nodes"
  default     = "c3.small.x86"
}

# variable "worker_node_plan_arm" {
#   type        = string
#   description = "Plan for K8s ARM Nodes"
#   default     = "c2.large.arm"
# }

# variable "worker_node_plan_gpu" {
#   type        = string
#   description = "Plan for GPU equipped nodes"
#   default     = "g2.large"
# }

variable "cluster_name" {
  type        = string
  description = "Name of your cluster. Alpha-numeric and hyphens only, please."
  default     = "metal-multiarch-k8s"
}

variable "control_plane_node_count" {
  type        = number
  description = "Number of control plane nodes (in addition to the primary controller)"
  default     = 3
}

variable "worker_node_count_x86" {
  type        = number
  default     = 3
  description = "Number of x86 nodes."
}

# variable "worker_node_count_arm" {
#   type        = number
#   default     = 0
#   description = "Number of ARM nodes."
# }

# variable "worker_node_count_gpu" {
#   type        = number
#   default     = 0
#   description = "Number of GPU nodes."
# }

variable "kubernetes_version" {
  type        = string
  description = "Version of Kubeadm to install"
  default     = "v1.21.7-rancher1-1"
}

variable "namespace" {
  type = string
  default = "bootstrap"
}

variable "ccm_version" {
  type        = string
  description = "The semver formatted version of the Equinix Metal CCM"
  default     = "v3.2.2"
}

variable "kube_vip_version" {
  type        = string
  description = "The semver formatted version of the Equinix Metal CCM"
  default     = "v0.4.0"
}
