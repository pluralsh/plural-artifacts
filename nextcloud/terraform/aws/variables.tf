variable "namespace" {
  type = string
  default = "nextcloud"
}

variable "nextcloud_bucket" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "nextcloud_serviceaccount" {
  type = string
  default = "nextcloud-serviceaccount"
}

variable "role_name" {
  type = string
  default = "nextcloud"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = false
  description = "If true, the bucket will be deleted even if it contains objects."
}
