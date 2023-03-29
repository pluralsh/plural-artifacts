variable "namespace" {
  type = string
  default = "mimir"
}

variable "cluster_name" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "storage_account_name" {
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
