variable "namespace" {
  type = string
  default = "monitoring"
}

variable "loki_bucket" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "loki_serviceaccount" {
  type = string
  default = "monitoring-loki"
}

variable "loki_distributed_serviceaccount" {
  type = string
  default = "monitoring-loki-distributed"
}

variable "role_name" {
  type = string
  default = "loki"
}
