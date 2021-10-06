variable "namespace" {
  type = string
  default = "kubeflow"
}

variable "pipelines_bucket" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "kubeflow_serviceaccount" {
  type = string
  default = "default-editor"
}

variable "role_name" {
  type = string
  default = "kubeflow"
}
variable "gpu_instance_type" {
  type = list(string)
  default = ["g4dn.xlarge"]
  description = "instance type to use in gpu node group"
}
