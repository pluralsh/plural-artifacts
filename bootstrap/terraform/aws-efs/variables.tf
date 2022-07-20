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

variable "cluster_worker_private_subnets" {
  type = list(any)
  description = "list of the cluster worker private subnets"
}

variable "cluster_worker_private_subnet_ids" {
  type = list(string)
  description = "list of ids of the cluster worker private subnets"
}
