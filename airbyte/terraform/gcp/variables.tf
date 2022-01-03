variable "namespace" {
  type = string
  default = "airbyte"
}

variable "airbyte_bucket" {
  type = string
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

variable "cluster_name" {
  type = string
  default = "plural"
}