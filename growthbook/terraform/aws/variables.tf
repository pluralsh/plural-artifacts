variable "namespace" {
  type = string
  default = "growthbook"
}

variable "cluster_name" {
  type = string
}

variable "growthbook_bucket" {
  type = string
  default = "growthbook"
}

variable "role_name" {
  type = string
  default = "growthbook"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = true
  description = "If true, the bucket will be deleted even if it contains objects."
}
