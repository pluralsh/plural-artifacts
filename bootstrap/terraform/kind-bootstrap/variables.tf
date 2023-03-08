variable "cluster_name" {
  type        = string
  description = "Name of your cluster. Alpha-numeric and hyphens only, please."
  default     = "kind"
}

variable "namespace" {
  type        = string
  description = "The kubernetes namespace for the bootstrap deployment"
  default     = "bootstrap"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version to use"
  default     = "v1.23.13"
}
