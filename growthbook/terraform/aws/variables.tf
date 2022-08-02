variable "namespace" {
  type = string
  default = "growthbook"
}

variable "cluster_name" {
  type = string
}

variable "growthbook_bucket" {
  type = string
  default = "growthbook"
}

variable "role_name" {
  type = string
  default = "growthbook"
}