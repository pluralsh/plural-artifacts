variable "namespace" {
  type = string
  default = "loki"
}

variable "cluster_name" {
  type = string
}

variable "loki_bucket" {
  type = string
}

variable "loki_serviceaccount" {
  type = string
  default = "loki"
}

variable "role_name" {
  type = string
  default = "loki"
}
