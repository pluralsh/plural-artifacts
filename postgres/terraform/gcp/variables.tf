variable "cluster_name" {
  type = string
  default = "plural"
}

variable "namespace" {
  type = string
  default = "postgres"
}

variable "wal_bucket" {
  type = string
}

variable "project_id" {
  type = string
  description = <<EOF
The ID of the project in which the resources belong.
EOF
}