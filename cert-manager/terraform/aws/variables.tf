variable "namespace" {
  type    = string
  default = "cert-manager"
}

variable "cluster_name" {
  type = string
}

variable "serviceaccount_name" {
  type    = string
  default = "cert-manager"
}
