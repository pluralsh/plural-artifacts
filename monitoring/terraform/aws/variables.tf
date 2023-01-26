variable "namespace" {
  type = string
  default = "monitoring"
}

variable "create" {
  type = bool
  default = true
  description = "whether you want to create the monitoring namespace"
}