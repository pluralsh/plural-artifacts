variable "namespace" {
  type = string
  default = "chatwoot"
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "chatwoot_serviceaccount" {
  type = string
  default = "chatwoot"
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

variable "chatwoot_bucket" {
  type = string
  description = "name of the bucket to use"
}
