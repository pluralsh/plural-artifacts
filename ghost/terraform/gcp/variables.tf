variable "cluster_name" {
  type = string
  default = "plural"
}

variable "namespace" {
  type = string
  default = "ghost"
}

variable "project_id" {
  type = string
  description = "The ID of the project in which the resources belong."
}

variable "mysql_serviceaccount" {
  type = string
  default = "mysql-pod"
}


variable "backup_bucket" {
  type = string
}
