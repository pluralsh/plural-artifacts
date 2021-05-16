variable "cluster_name" {
  type = string
  default = "plural"
}

variable "namespace" {
  type = string
  default = "console"
}

variable "gcp_location" {
  type = string
  default = "us-east1-b"
  description = <<EOF
The region you wish to deploy to
EOF
}


variable "project_id" {
  type = string
  description = <<EOF
The ID of the project in which the resources belong.
EOF
}

variable "airflow_bucket" {
  type = string
  description = "The bucket for storing airflow logs"
}