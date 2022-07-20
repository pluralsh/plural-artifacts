variable "namespace" {
  type = string
  default = "argo-workflows"
}


variable "project_id" {
  type = string
  description = <<EOF
The ID of the project in which the resources belong.
EOF
}

variable "workflow_bucket" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "plural"
}