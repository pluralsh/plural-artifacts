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
    small = {
      name = "small"
      capacity_type = "ON_DEMAND"
      min_capacity = 0
      desired_capacity = 0
      instance_types = ["m6i.large"]
      k8s_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
      }
      k8s_taints = [{
        key = "plural.sh/performanceType"
        value = "SUSTAINED"
        effect = "NO_SCHEDULE"
      }]
    }
    small_spot = {
      name = "small-spot"
      capacity_type = "SPOT"
      min_capacity = 0
      desired_capacity = 0
      instance_types = ["m6i.large"]
      k8s_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
      }
      k8s_taints = [
        {
          key = "plural.sh/capacityType"
          value = "SPOT"
          effect = "NO_SCHEDULE"
        },
        {
          key = "plural.sh/performanceType"
          value = "SUSTAINED"
          effect = "NO_SCHEDULE"
        }
      ]
    }
    small_burst = {
      name = "small-burst"
      capacity_type = "ON_DEMAND"
      min_capacity = 0
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
    medium = {
      name = "medium"
      instance_types = ["m6i.xlarge"]
      min_capacity = 0
      desired_capacity = 0
      capacity_type = "ON_DEMAND"
      k8s_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
      }
      k8s_taints = [{
        key = "plural.sh/performanceType"
        value = "SUSTAINED"
        effect = "NO_SCHEDULE"
      }]
    }
    medium_spot = {
      name = "medium-spot"
      instance_types = ["m6i.xlarge"]
      min_capacity = 0
      desired_capacity = 0
      capacity_type = "SPOT"
      k8s_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
      }
      k8s_taints = [
        {
          key = "plural.sh/capacityType"
          value = "SPOT"
          effect = "NO_SCHEDULE"
        },
        {
        key = "plural.sh/performanceType"
        value = "SUSTAINED"
        effect = "NO_SCHEDULE"
        }
      ]
    }
    medium_burst = {
      name = "medium-burst"
      instance_types = ["t3.xlarge", "t3a.xlarge"]
      min_capacity = 0
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
    large = {
      name = "large"
      instance_types = ["m6i.2xlarge"]
      min_capacity = 0
      desired_capacity = 0
      capacity_type = "ON_DEMAND"
      k8s_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
      }
      k8s_taints = [{
        key = "plural.sh/performanceType"
        value = "SUSTAINED"
        effect = "NO_SCHEDULE"
      }]
    }
    large_spot = {
      name = "large-spot"
      instance_types = ["m6i.2xlarge"]
      min_capacity = 0
      desired_capacity = 0
      capacity_type = "SPOT"
      k8s_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
      }

      k8s_taints = [
        {
          key = "plural.sh/capacityType"
          value = "SPOT"
          effect = "NO_SCHEDULE"
        },
        {
        key = "plural.sh/performanceType"
        value = "SUSTAINED"
        effect = "NO_SCHEDULE"
        }
      ]
    }
    large_burst = {
      name = "large-burst"
      instance_types = ["t3.2xlarge", "t3a.2xlarge"]
      min_capacity = 0
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