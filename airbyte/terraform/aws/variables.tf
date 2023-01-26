variable "namespace" {
  type = string
  default = "airbyte"
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "airbyte_bucket" {
  type = string
  default = "airbyte"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = true
  description = "If true, the bucket will be deleted even if it contains objects."
}
