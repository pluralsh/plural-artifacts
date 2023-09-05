variable "namespace" {
  type    = string
  default = "cert-manager"
}

variable "serviceaccount_name" {
  type    = string
  default = "cert-manager"
}

variable "cluster_name" {
  type = string
}

variable "gcp_project_id" {
  type        = string
  description = "The ID of the project in which the resources belong."
}
