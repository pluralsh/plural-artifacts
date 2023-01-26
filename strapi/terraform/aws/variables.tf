variable "namespace" {
  type = string
  default = "strapi"
}

variable "cluster_name" {
  type = string
}

variable "strapiBucket" {
  type = string
}

variable "role_name" {
  type = string
  default = "strapi"
}

variable "serviceaccount_name" {
  type = string
  default = "strapi"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = true
  description = "If true, the bucket will be deleted even if it contains objects."
}
