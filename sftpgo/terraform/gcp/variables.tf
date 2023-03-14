variable "namespace" {
  type = string
  default = "sftpgo"
}

variable "cluster_name" {
  type = string
}

variable "project_id" {
  type = string
  description = <<EOF
The ID of the project in which the resources belong.
EOF
}