variable "namespace" {
  type = string
  default = "minio"
}

variable "minio_bucket" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "minio_serviceaccount" {
  type = string
  default = "minio"
}

variable "role_name" {
  type = string
  default = "minio"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = false
  description = "If true, the bucket will be deleted even if it contains objects."
}
