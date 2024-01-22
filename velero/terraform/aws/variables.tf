variable "namespace" {
  type = string
  default = "velero"
}

variable "velero_bucket" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "velero_serviceaccount" {
  type = string
  default = "velero"
}

variable "role_name" {
  type = string
  default = "velero"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = false
  description = "If true, the bucket will be deleted even if it contains objects."
}
