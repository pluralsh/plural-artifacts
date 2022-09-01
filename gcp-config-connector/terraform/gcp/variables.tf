variable "namespace" {
  type = string
  default = "cnrm-system"
}

variable "cluster_name" {
  type = string
}

variable "project_id" {
  type = string
  description = "The ID of the project in which the resources belong."
}
