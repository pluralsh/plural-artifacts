variable "namespace" {
  type = string
  default = "postgres"
}

variable "wal_bucket" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "postgres_serviceaccount" {
  type = string
  default = "postgres-operator"
}

variable "role_name" {
  type = string
  default = "postgres"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = true
  description = "If true, the bucket will be deleted even if it contains objects."
}
