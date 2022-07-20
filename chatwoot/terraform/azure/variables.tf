variable "namespace" {
  type = string
  default = "chatwoot"
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "resource_group" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "chatwoot_container" {
  type = string
  description = "name of the storage container to use"
}
