variable "namespace" {
  type = string
  default = "kubeflow"
}

variable "pipelines_bucket" {
  type = string
}

variable "bucket_location" {
  type = string
  default = "US"
  description = "the location of the bucket"
}

variable "project_id" {
  type = string
  description = "The ID of the project in which the resources belong."
}

variable "cluster_name" {
  type = string
}
