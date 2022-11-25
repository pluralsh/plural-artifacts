variable "namespace" {
  type = string
  default = "strapi"
}

variable "cluster_name" {
  type = string
}

variable "strapiBucket" {
  type = string
}

variable "role_name" {
  type = string
  default = "strapi"
}

variable "serviceaccount_name" {
  type = string
  default = "strapi"
}
