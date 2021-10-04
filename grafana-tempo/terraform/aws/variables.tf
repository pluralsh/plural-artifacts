variable "cluster_name" {
  type = string
  default = "plural"
}

variable "namespace" {
  type = string
  default = "grafana-tempo"
}

variable "tempo_serviceaccount" {
  type = string
  default = "grafana-tempo"
  description = "name of the k8s service account for tempo"
}

variable "tempo_bucket" {
  type = string
  description = "name of the bucket to use"
}

variable "role_name" {
  type = string
  default = "tempo"
  description = "name of the IAM role for tempo to assume"
}
