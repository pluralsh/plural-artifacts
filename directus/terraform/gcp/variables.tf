variable "namespace" {
  type    = string
  default = "directus"
}

variable "directus_bucket" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "project_id" {
  type = string
}

variable "bucket_location" {
  type = string
}
