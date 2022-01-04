variable "cluster_name" {
  type = string
  default = "plural"
}

variable "namespace" {
  type = string
  default = "postgres"
}

variable "wal_bucket" {
  type = string
}