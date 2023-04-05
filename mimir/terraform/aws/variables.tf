variable "namespace" {
  type = string
  default = "mimir"
}

variable "cluster_name" {
  type = string
}

variable "mimir_blocks_bucket" {
  type = string
}

variable "mimir_alert_bucket" {
  type = string
}

variable "mimir_ruler_bucket" {
  type = string
}

variable "mimir_serviceaccount" {
  type = string
  default = "mimir"
}

variable "role_name" {
  type = string
  default = "mimir"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = false
  description = "If true, the bucket will be deleted even if it contains objects."
}
