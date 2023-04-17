variable "namespace" {
  type    = string
  default = "sftpgo"
}

variable "cluster_name" {
  type = string
}

variable "project_id" {
  type        = string
  description = <<EOF
The ID of the project in which the resources belong.
EOF
}

variable "roles" {
  type        = list(string)
  description = "A list of roles to be added to the sftpgo workload identity service account"
  default     = []
}
