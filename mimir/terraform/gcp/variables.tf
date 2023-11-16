variable "namespace" {
  type = string
  default = "mimir"
}

variable "cluster_name" {
  type = string
}

variable "mimir_serviceaccount" {
  type = string
  default = "mimir"
}