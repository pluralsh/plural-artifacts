variable "vpc_name" {
  type = string
  default = "forge"

  description = <<EOF
Name for the vpc for the cluster
EOF
}

variable "cluster_name" {
  type = string
  default = "plural"

  description = "name for the cluster"
}

variable "instance_types" {
  type = list(string)
  default = ["t3.large"]

  description = "instance type to use in node groups"
}

variable "min_capacity" {
  type = number
  default = 3

  description = "the minumum number of nodes for the initial nodegroup"
}

variable "desired_capacity" {
  type = number
  default = 3

  description = "the desired number of nodes for the initial nodegroup"
}

variable "max_capacity" {
  type = number
  default = 25

  description = "the maximum number of nodes in a nodegroup"
}

variable "autoscaler_serviceaccount" {
  type = string
  default = "cluster-autoscaler"
  description = "name of cluster autoscalers service account"
}

variable "ebs_csi_serviceaccount" {
  type = string
  default = "ebs-csi-controller"
  description = "name of cluster autoscalers service account"
}

variable "externaldns_serviceaccount" {
  type = string
  default = "external-dns"
  description = "name of externaldns' service account"
}

variable "certmanager_serviceaccount" {
  type = string
  default = "certmanager"
  description = "name of the certmanager service account"
}

variable "alb_serviceaccount" {
  type = string
  default = "alb-operator"
  description = "name of the nlb operator's service account"
}

variable "node_groups" {
  type = any
  default = {
    main = {
      name = "main"
    }
  }
  description = "Node groups for your cluster"
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = []
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = []
}

variable "manual_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap beyond the watchman user"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = []
}

variable "namespace" {
  type = string
  default = "bootstrap"
}