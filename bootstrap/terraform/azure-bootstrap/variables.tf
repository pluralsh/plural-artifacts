variable "network_name" {
  type = string
  default = "plural-vnet"
}

variable "subnet_name" {
  type = string
  default = "plural-subnet"
}

variable "network_plugin" {
  description = "Network plugin to use for networking."
  type        = string
  default     = "azure"
  nullable    = false
}

variable "network_policy" {
  description = " (Optional) Sets up network policy to be used with Azure CNI. Network policy allows us to control the traffic flow between pods. Currently supported values are calico and azure. Changing this forces a new resource to be created."
  type        = string
  default     = "azure"
}

variable "resource_group" {
  type = string
}

variable "kubernetes_version" {
  type = string
  default = "1.23.12"
}

variable "address_space" {
  type = string
  default = "10.1.0.0/16"
}

variable "subnet_prefixes" {
  type = list(string)
  default = ["10.1.0.0/18"]
}

variable "admin_username" {
  type = string
  default = null
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

variable "node_groups" {
  description = "list of maps of node groups to create. "
  type        = any
  default = [
    {
      name                = "ssod1"
      priority            = "Regular"
      enable_auto_scaling = true
      availability_zones  = ["1"]
      mode                = "System"
      node_count          = null
      min_count           = 1
      max_count           = 9
      spot_max_price      = null
      eviction_policy     = null
      vm_size             = "Standard_D2as_v5"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 50
      max_pods            = 110

      node_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "small-sustained-on-demand"
      }
      node_taints = []
      tags = {
        "ScalingGroup": "small-sustained-on-demand"
      }
    },
    {
      name                = "ssod2"
      priority            = "Regular"
      enable_auto_scaling = true
      availability_zones  = ["2"]
      mode                = "System"
      node_count          = null
      min_count           = 1
      max_count           = 9
      spot_max_price      = null
      eviction_policy     = null
      vm_size             = "Standard_D2as_v5"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 50
      max_pods            = 110

      node_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "small-sustained-on-demand"
      }
      node_taints = []
      tags = {
        "ScalingGroup": "small-sustained-on-demand"
      }
    },
    {
      name                = "ssod3"
      priority            = "Regular"
      enable_auto_scaling = true
      availability_zones  = ["3"]
      mode                = "System"
      node_count          = null
      min_count           = 1
      max_count           = 9
      spot_max_price      = null
      eviction_policy     = null
      vm_size             = "Standard_D2as_v5"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 50
      max_pods            = 110

      node_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "small-sustained-on-demand"
      }
      node_taints = []
      tags = {
        "ScalingGroup": "small-sustained-on-demand"
      }
    },
    {
      name                = "ssspot1"
      priority            = "Spot"
      enable_auto_scaling = true
      availability_zones  = ["1"]
      mode                = "User"
      node_count          = null
      min_count           = 0
      max_count           = 9
      spot_max_price      = -1
      eviction_policy     = "Delete"
      vm_size             = "Standard_D2as_v5"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 50
      max_pods            = 110

      node_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "small-sustained-spot"
        "kubernetes.azure.com/scalesetpriority" = "spot"
      }
      node_taints = [
        "plural.sh/capacityType=SPOT:NoSchedule",
        "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
      ]
      tags = {
        "ScalingGroup": "small-sustained-spot"
      }
    },
    {
      name                = "ssspot2"
      priority            = "Spot"
      enable_auto_scaling = true
      availability_zones  = ["2"]
      mode                = "User"
      node_count          = null
      min_count           = 0
      max_count           = 9
      spot_max_price      = -1
      eviction_policy     = "Delete"
      vm_size             = "Standard_D2as_v5"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 50
      max_pods            = 110

      node_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "small-sustained-spot"
        "kubernetes.azure.com/scalesetpriority" = "spot"
      }
      node_taints = [
        "plural.sh/capacityType=SPOT:NoSchedule",
        "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
      ]
      tags = {
        "ScalingGroup": "small-sustained-spot"
      }
    },
    {
      name                = "ssspot3"
      priority            = "Spot"
      enable_auto_scaling = true
      availability_zones  = ["3"]
      mode                = "User"
      node_count          = null
      min_count           = 0
      max_count           = 9
      spot_max_price      = -1
      eviction_policy     = "Delete"
      vm_size             = "Standard_D2as_v5"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 50
      max_pods            = 110

      node_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "small-sustained-spot"
        "kubernetes.azure.com/scalesetpriority" = "spot"
      }
      node_taints = [
        "plural.sh/capacityType=SPOT:NoSchedule",
        "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
      ]
      tags = {
        "ScalingGroup": "small-sustained-spot"
      }
    },

    {
      name                = "msod1"
      priority            = "Regular"
      enable_auto_scaling = true
      availability_zones  = ["1"]
      mode                = "User"
      node_count          = null
      min_count           = 0
      max_count           = 9
      spot_max_price      = null
      eviction_policy     = null
      vm_size             = "Standard_D4as_v5"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 50
      max_pods            = 110

      node_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "medium-sustained-on-demand"
      }
      node_taints = []
      tags = {
        "ScalingGroup": "medium-sustained-on-demand"
      }
    },
    {
      name                = "msod2"
      priority            = "Regular"
      enable_auto_scaling = true
      availability_zones  = ["2"]
      mode                = "User"
      node_count          = null
      min_count           = 0
      max_count           = 9
      spot_max_price      = null
      eviction_policy     = null
      vm_size             = "Standard_D4as_v5"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 50
      max_pods            = 110

      node_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "medium-sustained-on-demand"
      }
      node_taints = []
      tags = {
        "ScalingGroup": "medium-sustained-on-demand"
      }
    },
    {
      name                = "msod3"
      priority            = "Regular"
      enable_auto_scaling = true
      availability_zones  = ["3"]
      mode                = "User"
      node_count          = null
      min_count           = 0
      max_count           = 9
      spot_max_price      = null
      eviction_policy     = null
      vm_size             = "Standard_D4as_v5"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 50
      max_pods            = 110

      node_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "medium-sustained-on-demand"
      }
      node_taints = []
      tags = {
        "ScalingGroup": "medium-sustained-on-demand"
      }
    },
    {
      name                = "msspot1"
      priority            = "Spot"
      enable_auto_scaling = true
      availability_zones  = ["1"]
      mode                = "User"
      node_count          = null
      min_count           = 0
      max_count           = 9
      spot_max_price      = -1
      eviction_policy     = "Delete"
      vm_size             = "Standard_D4as_v5"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 50
      max_pods            = 110

      node_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "medium-sustained-spot"
        "kubernetes.azure.com/scalesetpriority" = "spot"
      }
      node_taints = [
        "plural.sh/capacityType=SPOT:NoSchedule",
        "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
      ]
      tags = {
        "ScalingGroup": "medium-sustained-spot"
      }
    },
    {
      name                = "msspot2"
      priority            = "Spot"
      enable_auto_scaling = true
      availability_zones  = ["2"]
      mode                = "User"
      node_count          = null
      min_count           = 0
      max_count           = 9
      spot_max_price      = -1
      eviction_policy     = "Delete"
      vm_size             = "Standard_D4as_v5"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 50
      max_pods            = 110

      node_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "medium-sustained-spot"
        "kubernetes.azure.com/scalesetpriority" = "spot"
      }
      node_taints = [
        "plural.sh/capacityType=SPOT:NoSchedule",
        "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
      ]
      tags = {
        "ScalingGroup": "medium-sustained-spot"
      }
    },
    {
      name                = "msspot3"
      priority            = "Spot"
      enable_auto_scaling = true
      availability_zones  = ["3"]
      mode                = "User"
      node_count          = null
      min_count           = 0
      max_count           = 9
      spot_max_price      = -1
      eviction_policy     = "Delete"
      vm_size             = "Standard_D4as_v5"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 50
      max_pods            = 110

      node_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "medium-sustained-spot"
        "kubernetes.azure.com/scalesetpriority" = "spot"
      }
      node_taints = [
        "plural.sh/capacityType=SPOT:NoSchedule",
        "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
      ]
      tags = {
        "ScalingGroup": "medium-sustained-spot"
      }
    },

    {
      name                = "lsod1"
      priority            = "Regular"
      enable_auto_scaling = true
      availability_zones  = ["1"]
      mode                = "User"
      node_count          = null
      min_count           = 0
      max_count           = 9
      spot_max_price      = null
      eviction_policy     = null
      vm_size             = "Standard_D8as_v5"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 50
      max_pods            = 110

      node_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "large-sustained-on-demand"
      }
      node_taints = []
      tags = {
        "ScalingGroup": "large-sustained-on-demand"
      }
    },
    {
      name                = "lsod2"
      priority            = "Regular"
      enable_auto_scaling = true
      availability_zones  = ["2"]
      mode                = "User"
      node_count          = null
      min_count           = 0
      max_count           = 9
      spot_max_price      = null
      eviction_policy     = null
      vm_size             = "Standard_D8as_v5"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 50
      max_pods            = 110

      node_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "large-sustained-on-demand"
      }
      node_taints = []
      tags = {
        "ScalingGroup": "large-sustained-on-demand"
      }
    },
    {
      name                = "lsod3"
      priority            = "Regular"
      enable_auto_scaling = true
      availability_zones  = ["3"]
      mode                = "User"
      node_count          = null
      min_count           = 0
      max_count           = 9
      spot_max_price      = null
      eviction_policy     = null
      vm_size             = "Standard_D8as_v5"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 50
      max_pods            = 110

      node_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "large-sustained-on-demand"
      }
      node_taints = []
      tags = {
        "ScalingGroup": "large-sustained-on-demand"
      }
    },
    {
      name                = "lsspot1"
      priority            = "Spot"
      enable_auto_scaling = true
      availability_zones  = ["1"]
      mode                = "User"
      node_count          = null
      min_count           = 0
      max_count           = 9
      spot_max_price      = -1
      eviction_policy     = "Delete"
      vm_size             = "Standard_D8as_v5"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 50
      max_pods            = 110

      node_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "large-sustained-spot"
        "kubernetes.azure.com/scalesetpriority" = "spot"
      }
      node_taints = [
        "plural.sh/capacityType=SPOT:NoSchedule",
        "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
      ]
      tags = {
        "ScalingGroup": "large-sustained-spot"
      }
    },
    {
      name                = "lsspot2"
      priority            = "Spot"
      enable_auto_scaling = true
      availability_zones  = ["2"]
      mode                = "User"
      node_count          = null
      min_count           = 0
      max_count           = 9
      spot_max_price      = -1
      eviction_policy     = "Delete"
      vm_size             = "Standard_D8as_v5"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 50
      max_pods            = 110

      node_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "large-sustained-spot"
        "kubernetes.azure.com/scalesetpriority" = "spot"
      }
      node_taints = [
        "plural.sh/capacityType=SPOT:NoSchedule",
        "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
      ]
      tags = {
        "ScalingGroup": "large-sustained-spot"
      }
    },
    {
      name                = "lsspot3"
      priority            = "Spot"
      enable_auto_scaling = true
      availability_zones  = ["3"]
      mode                = "User"
      node_count          = null
      min_count           = 0
      max_count           = 9
      spot_max_price      = -1
      eviction_policy     = "Delete"
      vm_size             = "Standard_D8as_v5"
      os_disk_type        = "Managed"
      os_disk_size_gb     = 50
      max_pods            = 110

      node_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "large-sustained-spot"
        "kubernetes.azure.com/scalesetpriority" = "spot"
      }
      node_taints = [
        "plural.sh/capacityType=SPOT:NoSchedule",
        "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
      ]
      tags = {
        "ScalingGroup": "large-sustained-spot"
      }
    }
  ]
}

variable "auto_scaler_profile_enabled" {
  description = "Enable or Disable configuring the autoscaler profile."
  type        = bool
  default     = true
}

variable "auto_scaler_profile_new_pod_scale_up_delay" {
  description = "For scenarios like burst/batch scale where you don't want CA to act before the kubernetes scheduler could schedule all the pods, you can tell CA to ignore unscheduled pods before they're a certain age. Defaults to `10s`."
  type        = string
  default     = "0s"
}

variable "auto_scaler_profile_balance_similar_node_groups" {
  description = "Enable or Disable the balance similar node groups."
  type        = bool
  default     = true
}

variable "auto_scaler_profile_skip_nodes_with_local_storage" {
  description = "Do not check nodes that have local storage, pods using it will not be moved."
  type        = bool
  default     = false
}

variable "auto_scaler_profile_scale_down_utilization_threshold" {
  description = "The threshold in % under which a node is considered for scale down."
  type        = string
  default     = "0.7"
}

variable "enable_aks_insights" {
  description = "enable aks logging and monitoring (defaults to false because it can be quite expensive)"
  type        = bool
  default     = false
}