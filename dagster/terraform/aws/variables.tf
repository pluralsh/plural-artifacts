variable "namespace" {
  type = string
  default = "dagster"
}

variable "cluster_name" {
  type = string
}

variable "dagster_bucket" {
  type = string
}

variable "dagster_serviceaccount" {
  type = string
  default = "dagster"
}

variable "role_name" {
  type = string
  default = "dagster"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = true
  description = "If true, the bucket will be deleted even if it contains objects."
}
