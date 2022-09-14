variable "network_name" {
  type = string
  default = "plural-vnet"
}

variable "subnet_name" {
  type = string
  default = "plural-subnet"
}

variable "resource_group" {
  type = string
}

variable "kubernetes_version" {
  type = string
  default = "1.21.9"
}

variable "address_space" {
  type = string
  default = "10.1.0.0/16"
}

variable "subnet_prefixes" {
  type = list(string)
  default = ["10.1.0.0/22"]
}

variable "name" {
  type = string
  default = "plural"
}

variable "os_disk_size" {
  type = number
  default = 50
}

variable "os_disk_type" {
  type = string
  default = "Ephemeral"
}

variable "agents_size" {
  default     = "Standard_D2s_v3"
  description = "The default virtual machine size for the Kubernetes agents"
  type        = string
}

variable "private_cluster" {
  type = bool
  default = false
}

variable "min_nodes" {
  type = number
  default = 3
}

variable "max_nodes" {
  type = number
  default = 25
}

variable "namespace" {
  type = string
  default = "bootstrap"
}