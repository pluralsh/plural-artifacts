variable "namespace" {
  type = string
  default = "harbor"
}

variable "cluster_name" {
  type = string
}

variable "project_id" {
  type = string
  description = "The ID of the project in which the resources belong."
}

variable "bucket" {
  type = string
}

variable "bucket_location" {
  type = string
}

variable "harbor_serviceaccount" {
  type = string
  default = "harbor"
}
