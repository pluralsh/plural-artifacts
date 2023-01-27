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

variable "force_destroy_bucket" {
  type        = bool
  default     = false
  description = "If true, the bucket will be deleted even if it contains objects."
}
