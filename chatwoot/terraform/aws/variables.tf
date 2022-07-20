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
