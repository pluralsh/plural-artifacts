variable "cluster_name" {
  type        = string
  description = "Name of your cluster. Alpha-numeric and hyphens only, please."
  default     = "kind"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version to use"
  default     = "v1.21.10"
}
