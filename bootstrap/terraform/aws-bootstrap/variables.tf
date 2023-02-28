variable "vpc_name" {
  type = string
  default = "forge"

  description = <<EOF
Name for the vpc for the cluster
EOF
}

variable "kubernetes_version" {
  type = string
  description = "Kubernetes version to use for the cluster"
  default = "1.22"
}

variable "vpc_cni_addon_version" {
  type = string
  default = "v1.12.0-eksbuild.2"
  description = "The version of the VPC-CNI addon to use"
}

variable "core_dns_addon_version" {
  type = string
  default = "v1.8.7-eksbuild.1"
  description = "The version of the CoreDNS addon to use"
}

variable "kube_proxy_addon_version" {
  type = string
  default = "v1.22.16-eksbuild.3"
  description = "The version of the kube-proxy addon to use"
}

variable "enable_ebs_csi_driver" {
  type = bool
  default = true
  description = "Whether to enable the EBS CSI driver"
}

variable "enable_cluster_autoscaler" {
  type = bool
  default = true
  description = "Whether to enable the cluster autoscaler"
}

variable "enable_aws_lb_controller" {
  type = bool
  default = true
  description = "Whether to enable the AWS LB controller"
}

variable "create_cluster" {
  type = bool
  default = true
  description = "Whether to create a fresh cluster, or simply reference an existing one"
}

variable "create_vpc" {
  type = bool
  default = true
  description = "Whether to create a fresh vpc, or simply reference an existing one"
}

variable "eks_oidc_root_ca_thumbprint" {
  type        = string
  description = "Thumbprint of Root CA for EKS OIDC, Valid until 2037"
  default     = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
}

variable "enable_irsa" {
  type = bool
  default = true
  description = "whether to enable the irsa oidc provider for your cluster (only relevant for byok)"
}

variable "enable_vpc_s3_endpoint" {
  type = bool
  default = true
  description = "whether to enable creation of a vpc endpoint to s3 to mitigate bandwidth cost (disable if one exists already)"
}

variable "private_subnet_ids" {
  type = list(string)
  default = []
  description = "private subnet ids for your existing cluster (will be ignored if not deployed in BYOK mode)"
}

variable "worker_private_subnet_ids" {
  type = list(string)
  default = []
  description = "private subnet ids for the worker nodes of your cluster (will be ignored if not deployed in BYOK mode)"
}

variable "public_subnet_ids" {
  type = list(string)
  default = []
  description = "public subnet ids for your existing clsuter (will be ignored if not deployed in BYOK mode)"
}

variable "cluster_name" {
  type = string
  default = "plural"

  description = "name for the cluster"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"

  description = "The CIDR for the VPC created for the EKS cluster and it's worker nodes"
}

variable "public_subnets" {
  type = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  description = "Public subnets for the EKS cluster"
}

variable "private_subnets" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  description = "Private subnets for the EKS cluster"
}

variable "worker_private_subnets" {
  type = list(string)
  default = ["10.0.16.0/20", "10.0.32.0/20", "10.0.48.0/20"]

  description = "Private subnets for the workers of the EKS cluster"
}

variable "database_subnets" {
  type = list(string)
  default = []

  description = "A list of database subnets"
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
    ami_release_version = "1.22.15-20221222"
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
  }
  description = "Node groups to add to your cluster. A single managed node group will be created in each availability zone."
}

variable "multi_az_node_groups" {
  type = any
  default = {
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

variable "aws_region" {
  type = string
  default = "us-east-2"
  description = "The region you wish to deploy to"
}
