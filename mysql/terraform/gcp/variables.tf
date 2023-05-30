variable "cluster_name" {
  type = string
  default = "plural"
}

variable "namespace" {
  type = string
  default = "mysql"
}

variable "project_id" {
  type = string
  description = "The ID of the project in which the resources belong."
}

variable "mysql_serviceaccount" {
  type = string
  default = "mysql-operator"
}

variable "backup_bucket" {
  type = string
}

variable "bucket_location" {
  type = string
}
