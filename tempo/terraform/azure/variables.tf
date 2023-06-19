variable "cluster_name" {
  type = string
  default = "plural"
}

variable "namespace" {
  type = string
  default = "tempo"
}

variable "resource_group" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "tempo_container" {
  type = string
  description = "name of the storage container to use"
}
