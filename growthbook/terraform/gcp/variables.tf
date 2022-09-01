variable "namespace" {
  type = string
  default = "growthbook"
}

variable "cluster_name" {
  type = string
}

variable "project_id" { 
  type = string
}

variable "growthbook_bucket" {
  type = string
  default = "growthbook"
}