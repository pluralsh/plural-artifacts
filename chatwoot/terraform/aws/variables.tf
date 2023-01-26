variable "namespace" {
  type = string
  default = "chatwoot"
}

variable "chatwoot_bucket" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "chatwoot_serviceaccount" {
  type = string
  default = "chatwoot"
}

variable "role_name" {
  type = string
  default = "chatwoot"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = false
  description = "If true, the bucket will be deleted even if it contains objects."
}
