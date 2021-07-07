variable "namespace" {
  type = string
  default = "mysql"
}

variable "backup_bucket" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "mysql_serviceaccount" {
  type = string
  default = "mysql-operator"
}