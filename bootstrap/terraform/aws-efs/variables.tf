variable "cluster_name" {
  type = string
  default = "plural"

  description = "name for the cluster"
}

variable "vpc_name" {
  type = string
  default = "plural"
  description = "Name for the vpc for the cluster"
}

variable "namespace" {
  type = string
  default = "bootstrap"
}

variable "efs_csi_serviceaccount" {
  type = string
  default = "efs-csi-controller"
  description = "name of cluster efs csi driver service account"
}
