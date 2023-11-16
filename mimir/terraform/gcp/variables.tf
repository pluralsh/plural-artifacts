variable "namespace" {
  type = string
  default = "mimir"
}

variable "cluster_name" {
  type = string
}

variable "mimir_serviceaccount" {
  type = string
  default = "mimir"
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

variable "bucket_location" {
  type = string
}