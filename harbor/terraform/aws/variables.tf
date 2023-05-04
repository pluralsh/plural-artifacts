variable "namespace" {
  type    = string
  default = "harbor"
}

variable "cluster_name" {
  type = string
}

variable "bucket" {
  type = string
}

variable "harbor_serviceaccount" {
  type    = string
  default = "harbor"
}

variable "role_name" {
  type    = string
  default = "harbor"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = false
  description = "If true, the bucket will be deleted even if it contains objects."
}
