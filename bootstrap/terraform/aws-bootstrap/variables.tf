variable "vpc_name" {
  type = string
  default = "forge"

  description = <<EOF
Name for the vpc for the cluster
EOF
}

variable "cluster_enabled_log_types" {
  default     = []
  description = "A list of the desired control plane logging to enable. Supported options are: api, audit, authenticator, controllerManager, scheduler. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
}

variable "cluster_log_kms_key_id" {
  default     = ""
  description = "If a KMS Key ARN is set, this key will be used to encrypt the corresponding log group. Please be sure that the KMS Key has an appropriate key policy (https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html)"
  type        = string
}

variable "cluster_log_retention_in_days" {
  default     = 90
  description = "Number of days to retain log events. Default retention - 90 days."
  type        = number
}

variable "kubernetes_version" {
  type = string
  description = "Kubernetes version to use for the cluster"
  default = "1.23"
}

variable "vpc_cni_addon_version" {
  type = string
  default = "v1.12.5-eksbuild.1"
  description = "The version of the VPC-CNI addon to use"
}

variable "core_dns_addon_version" {
  type = string
  default = "v1.8.7-eksbuild.4"
  description = "The version of the CoreDNS addon to use"
}

variable "kube_proxy_addon_version" {
  type = string
  default = "v1.23.15-eksbuild.1"
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
    ami_release_version = "1.23.16-20230217"
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


## Launch Template vars

variable "generate_launch_template" {
  type = bool
  default = false
  description = "whether to generate a custom launch template for your nodes, useful for customizing security configuration or base ami"
}

variable "block_device_map" {
  type = map(object({
    no_device    = optional(bool, null)
    virtual_name = optional(string, null)
    ebs = optional(object({
      delete_on_termination = optional(bool, true)
      encrypted             = optional(bool, true)
      iops                  = optional(number, null)
      kms_key_id            = optional(string, null)
      snapshot_id           = optional(string, null)
      throughput            = optional(number, null)
      volume_size           = optional(number, 20)
      volume_type           = optional(string, "gp3")
    }))
  }))

  description = <<-EOT
    Map of block device name specification, see [launch_template.block-devices](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#block-devices).
    EOT
  # See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#ebs
  default = { "/dev/xvda" = { ebs = {} } }
}

variable "update_config" {
  type        = list(map(number))
  default     = []
  description = <<-EOT
    Configuration for the `eks_node_group` [`update_config` Configuration Block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group#update_config-configuration-block).
    Specify exactly one of `max_unavailable` (node count) or `max_unavailable_percentage` (percentage of nodes).
    EOT
}

variable "kubelet_additional_options" {
  type        = list(string)
  description = <<-EOT
    Additional flags to pass to kubelet.
    DO NOT include `--node-labels` or `--node-taints`,
    use `kubernetes_labels` and `kubernetes_taints` to specify those."
    EOT
  default     = []
  validation {
    condition = (length(compact(var.kubelet_additional_options)) == 0 ? true :
      length(regexall("--node-labels", join(" ", var.kubelet_additional_options))) == 0 &&
      length(regexall("--node-taints", join(" ", var.kubelet_additional_options))) == 0
    )
    error_message = "Var kubelet_additional_options must not contain \"--node-labels\" or \"--node-taints\".  Use `kubernetes_labels` and `kubernetes_taints` to specify labels and taints."
  }
}

variable "ami_image_id" {
  type        = string
  default     = null
  description = "AMI to use"
}

variable "ami_release_version" {
  type        = list(string)
  default     = []
  description = "EKS AMI version to use, e.g. For AL2 \"1.16.13-20200821\" or for bottlerocket \"1.2.0-ccf1b754\" (no \"v\") or  for Windows \"2023.02.14\". For AL2, bottlerocket and Windows, it defaults to latest version for Kubernetes version."
  validation {
    condition = (
      length(var.ami_release_version) == 0 ? true : length(regexall("(^\\d+\\.\\d+\\.\\d+-[\\da-z]+$)|(^\\d+\\.\\d+\\.\\d+$)", var.ami_release_version[0])) == 1
    )
    error_message = "Var ami_release_version, if supplied, must be like for AL2 \"1.16.13-20200821\" or for bottlerocket \"1.2.0-ccf1b754\" (no \"v\") or for Windows \"2023.02.14\"."
  }
}

variable "resources_to_tag" {
  type        = list(string)
  description = "List of auto-launched resource types to tag. Valid types are \"instance\", \"volume\", \"elastic-gpu\", \"spot-instances-request\", \"network-interface\"."
  default     = ["instance", "volume", "network-interface"]
  validation {
    condition = (
      length(compact([for r in var.resources_to_tag : r if !contains(["instance", "volume", "elastic-gpu", "spot-instances-request", "network-interface"], r)])) == 0
    )
    error_message = "Invalid resource type in `resources_to_tag`. Valid types are \"instance\", \"volume\", \"elastic-gpu\", \"spot-instances-request\", \"network-interface\"."
  }
}

variable "before_cluster_joining_userdata" {
  type        = list(string)
  default     = []
  description = "Additional `bash` commands to execute on each worker node before joining the EKS cluster (before executing the `bootstrap.sh` script). For more info, see https://kubedex.com/90-days-of-aws-eks-in-production"
  validation {
    condition = (
      length(var.before_cluster_joining_userdata) < 2
    )
    error_message = "You may not specify more than one `before_cluster_joining_userdata`."
  }
}

variable "after_cluster_joining_userdata" {
  type        = list(string)
  default     = []
  description = "Additional `bash` commands to execute on each worker node after joining the EKS cluster (after executing the `bootstrap.sh` script). For more info, see https://kubedex.com/90-days-of-aws-eks-in-production"
  validation {
    condition = (
      length(var.after_cluster_joining_userdata) < 2
    )
    error_message = "You may not specify more than one `after_cluster_joining_userdata`."
  }
}

variable "bootstrap_additional_options" {
  type        = list(string)
  default     = []
  description = "Additional options to bootstrap.sh. DO NOT include `--kubelet-additional-args`, use `kubelet_additional_options` var instead."
  validation {
    condition = (
      length(var.bootstrap_additional_options) < 2
    )
    error_message = "You may not specify more than one `bootstrap_additional_options`."
  }
}

variable "userdata_override_base64" {
  type        = list(string)
  default     = []
  description = <<-EOT
    Many features of this module rely on the `bootstrap.sh` provided with Amazon Linux, and this module
    may generate "user data" that expects to find that script. If you want to use an AMI that is not
    compatible with the Amazon Linux `bootstrap.sh` initialization, then use `userdata_override_base64` to provide
    your own (Base64 encoded) user data. Use "" to prevent any user data from being set.

    Setting `userdata_override_base64` disables `kubernetes_taints`, `kubelet_additional_options`,
    `before_cluster_joining_userdata`, `after_cluster_joining_userdata`, and `bootstrap_additional_options`.
    EOT
  validation {
    condition = (
      length(var.userdata_override_base64) < 2
    )
    error_message = "You may not specify more than one `userdata_override_base64`."
  }
}

variable "metadata_http_endpoint_enabled" {
  type        = bool
  default     = true
  description = "Set false to disable the Instance Metadata Service."
}

variable "metadata_http_put_response_hop_limit" {
  type        = number
  default     = 2
  description = <<-EOT
    The desired HTTP PUT response hop limit (between 1 and 64) for Instance Metadata Service requests.
    The default is `2` to allows containerized workloads assuming the instance profile, but it's not really recomended. You should use OIDC service accounts instead.
    EOT
  validation {
    condition = (
      var.metadata_http_put_response_hop_limit >= 1
    )
    error_message = "IMDS hop limit must be at least 1 to work."
  }
}

variable "metadata_http_tokens_required" {
  type        = bool
  default     = true
  description = "Set true to require IMDS session tokens, disabling Instance Metadata Service Version 1."
}

variable "placement" {
  type        = list(any)
  default     = []
  description = <<-EOT
    Configuration for the [`placement` Configuration Block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#placement) of the launch template.
    Leave list empty for defaults. Pass list with single object with attributes matching the `placement` block to configure it.
    Note that this configures the launch template only. Some elements will be ignored by the Auto Scaling Group
    that actually launches instances. Consult AWS documentation for details.
    EOT
}

variable "cpu_options" {
  type        = list(any)
  default     = []
  description = <<-EOT
    Configuration for the [`cpu_options` Configuration Block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template#cpu_options) of the launch template.
    Leave list empty for defaults. Pass list with single object with attributes matching the `cpu_options` block to configure it.
    Note that this configures the launch template only. Some elements will be ignored by the Auto Scaling Group
    that actually launches instances. Consult AWS documentation for details.
    EOT
}

variable "enclave_enabled" {
  type        = bool
  default     = false
  description = "Set to `true` to enable Nitro Enclaves on the instance."
}

variable "detailed_monitoring_enabled" {
  type        = bool
  default     = false
  description = "The launched EC2 instance will have detailed monitoring enabled. Defaults to false"
}