variable "namespace" {
  type    = string
  default = "directus"
}

variable "cluster_name" {
  type = string
}

variable "directus_bucket" {
  type = string
}

variable "force_destroy_bucket" {
  type = bool
  default = true
}

variable "serviceaccount_name" {
  type = string
  default = "directus"
}