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

variable "node_groups_defaults" {
  description = "map of maps of node groups to create. See \"`node_groups` and `node_groups_defaults` keys\" section in README.md for more details"
  type        = any
  default = {
    desired_capacity = 0
    min_capacity = 0
    max_capacity = 27

    instance_types = ["t3.large", "t3a.large"]
    disk_size = 50
    ami_release_version = "1.21.5-20220123"
    force_update_version = true
    ami_type = "AL2_x86_64"
    k8s_labels = {}
    k8s_taints = []
  }
}

variable "single_az_node_groups" {
  type = any
  default = {
    small_burst_on_demand = {
      name = "small-burst-on-demand"
      capacity_type = "ON_DEMAND"
      min_capacity = 3
      desired_capacity = 3
      instance_types = ["t3.large", "t3a.large"]
      k8s_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "BURST"
        "plural.sh/scalingGroup" = "small-burst-on-demand"
      }
    }
    small_burst_spot = {
      name = "small-burst-spot"
      capacity_type = "SPOT"
      instance_types = ["t3.large", "t3a.large"]
      k8s_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "BURST"
        "plural.sh/scalingGroup" = "small-burst-spot"
      }
      k8s_taints = [{
        key = "plural.sh/capacityType"
        value = "SPOT"
        effect = "NO_SCHEDULE"
      }]
    }
    medium_burst_on_demand = {
      name = "medium-burst-on-demand"
      instance_types = ["t3.xlarge", "t3a.xlarge"]
      capacity_type = "ON_DEMAND"
      k8s_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "BURST"
        "plural.sh/scalingGroup" = "medium-burst-on-demand"
      }
    }
    medium_burst_spot = {
      name = "medium-burst-spot"
      instance_types = ["t3.xlarge", "t3a.xlarge"]
      capacity_type = "SPOT"
      k8s_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "BURST"
        "plural.sh/scalingGroup" = "medium-burst-spot"
      }
      k8s_taints = [{
        key = "plural.sh/capacityType"
        value = "SPOT"
        effect = "NO_SCHEDULE"
      }]
    }
    large_burst_on_demand = {
      name = "large-burst-on-demand"
      instance_types = ["t3.2xlarge", "t3a.2xlarge"]
      capacity_type = "ON_DEMAND"
      k8s_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "BURST"
        "plural.sh/scalingGroup" = "large-burst-on-demand"
      }
    }
    large_burst_spot = {
      name = "large-burst-spot"
      instance_types = ["t3.2xlarge", "t3a.2xlarge"]
      capacity_type = "SPOT"
      k8s_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "BURST"
        "plural.sh/scalingGroup" = "large-burst-spot"
      }

      k8s_taints = [{
        key = "plural.sh/capacityType"
        value = "SPOT"
        effect = "NO_SCHEDULE"
      }]
    }
  }
  description = "Node groups to add to your cluster. A single managed node group will be created in each availability zone."
}

variable "multi_az_node_groups" {
  type = any
  default = {}
  description = "Node groups to add to your cluster. A single managed node group will be created across all availability zones."
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