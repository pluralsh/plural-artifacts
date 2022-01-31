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

variable "max_managed_node_groups" {
  type = number
  default = 100

  description = "the maximum number of managed node groups per cluster in the region"
}

variable "max_auto_scaling_groups" {
  type = number
  default = 1000

  description = "the maximum number of auto scaling groups in the region"
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
  default = {}
  description = "Manually configured node groups to add to your cluster"
}

variable "base_node_groups" {
  type = any
  default = {
    small_sustained_on_demand = {
      name = "small-sustained-on-demand"
      capacity_type = "ON_DEMAND"
      min_capacity = 0
      max_capacity = 25
      desired_capacity = 0
      instance_types = ["m6i.large"]
      k8s_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
      }
    }
    small_sustained_spot = {
      name = "small-sustained-spot"
      capacity_type = "SPOT"
      min_capacity = 0
      max_capacity = 25
      desired_capacity = 0
      instance_types = ["m6i.large"]
      k8s_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
      }
      k8s_taints = [{
        key = "plural.sh/capacityType"
        value = "SPOT"
        effect = "NO_SCHEDULE"
      }]
    }
    small_burst_on_demand = {
      name = "small-burst-on-demand"
      capacity_type = "ON_DEMAND"
      min_capacity = 0
      max_capacity = 25
      desired_capacity = 3
      instance_types = ["t3.large", "t3a.large"]
      k8s_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "BURST"
      }
    }
    small_burst_spot = {
      name = "small-burst-spot"
      capacity_type = "SPOT"
      min_capacity = 0
      max_capacity = 25
      desired_capacity = 0
      instance_types = ["t3.large", "t3a.large"]
      k8s_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "BURST"
      }
      k8s_taints = [{
        key = "plural.sh/capacityType"
        value = "SPOT"
        effect = "NO_SCHEDULE"
      }]
    }
    medium_sustained_on_demand = {
      name = "medium-sustained-on-demand"
      instance_types = ["m6i.xlarge"]
      min_capacity = 0
      max_capacity = 25
      desired_capacity = 0
      capacity_type = "ON_DEMAND"
      k8s_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
      }
    }
    medium_sustained_spot = {
      name = "medium-sustained-spot"
      instance_types = ["m6i.xlarge"]
      min_capacity = 0
      max_capacity = 25
      desired_capacity = 0
      capacity_type = "SPOT"
      k8s_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
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
      min_capacity = 0
      max_capacity = 25
      desired_capacity = 0
      capacity_type = "ON_DEMAND"
      k8s_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "BURST"
      }
    }
    medium_burst_spot = {
      name = "medium-burst-spot"
      instance_types = ["t3.xlarge", "t3a.xlarge"]
      min_capacity = 0
      max_capacity = 25
      desired_capacity = 0
      capacity_type = "SPOT"
      k8s_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "BURST"
      }
      k8s_taints = [{
        key = "plural.sh/capacityType"
        value = "SPOT"
        effect = "NO_SCHEDULE"
      }]
    }
    large_sustained_on_demand = {
      name = "large-sustained-on-demand"
      instance_types = ["m6i.2xlarge"]
      min_capacity = 0
      max_capacity = 25
      desired_capacity = 0
      capacity_type = "ON_DEMAND"
      k8s_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
      }
    }
    large_sustained_spot = {
      name = "large-sustained-spot"
      instance_types = ["m6i.2xlarge"]
      min_capacity = 0
      max_capacity = 25
      desired_capacity = 0
      capacity_type = "SPOT"
      k8s_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
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
      min_capacity = 0
      max_capacity = 25
      desired_capacity = 0
      capacity_type = "ON_DEMAND"
      k8s_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "BURST"
      }
    }
    large_burst_spot = {
      name = "large-burst-spot"
      instance_types = ["t3.2xlarge", "t3a.2xlarge"]
      min_capacity = 0
      max_capacity = 25
      desired_capacity = 0
      capacity_type = "SPOT"
      k8s_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "BURST"
      }

      k8s_taints = [{
        key = "plural.sh/capacityType"
        value = "SPOT"
        effect = "NO_SCHEDULE"
      }]
    }
  }
  description = "Plural Base node groups for your cluster"
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