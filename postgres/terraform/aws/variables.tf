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
