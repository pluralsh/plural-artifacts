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
  default = "1.22.11"
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
      name = "ssod"
      priority = "Regular"
      enable_auto_scaling = true
      availability_zones = ["1", "2", "3"]

      node_count = null
      min_count = 3
      max_count = 27

      vm_size = "Standard_D2as_v5"

      os_disk_type = "Managed"

      os_disk_size_gb = 50

      max_pods = 110


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
      name = "ssspot"
      priority = "Spot"
      enable_auto_scaling = true
      availability_zones = ["1", "2", "3"]

      node_count = null
      min_count = 0
      max_count = 27

      spot_max_price = -1
      eviction_policy = "Delete"

      vm_size = "Standard_D2as_v5"

      os_disk_type = "Managed"

      os_disk_size_gb = 50

      max_pods = 110


      node_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "small-sustained-spot"
      }
      node_taints = [
        "plural.sh/capacityType=SPOT:NoSchedule"
      ]
      tags = {
        "ScalingGroup": "small-sustained-spot"
      }
    },

    {
      name = "msod"
      priority = "Regular"
      enable_auto_scaling = true
      availability_zones = ["1", "2", "3"]

      node_count = null
      min_count = 0
      max_count = 27

      vm_size = "Standard_D4as_v5"

      os_disk_type = "Managed"

      os_disk_size_gb = 50

      max_pods = 110


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
      name = "msspot"
      priority = "Spot"
      enable_auto_scaling = true
      availability_zones = ["1", "2", "3"]

      node_count = null
      min_count = 0
      max_count = 27

      spot_max_price = -1
      eviction_policy = "Delete"

      vm_size = "Standard_D4as_v5"

      os_disk_type = "Managed"

      os_disk_size_gb = 50

      max_pods = 110


      node_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "medium-sustained-spot"
      }
      node_taints = [
        "plural.sh/capacityType=SPOT:NoSchedule"
      ]
      tags = {
        "ScalingGroup": "medium-sustained-spot"
      }
    },

    {
      name = "lsod"
      priority = "Regular"
      enable_auto_scaling = true
      availability_zones = ["1", "2", "3"]

      node_count = null
      min_count = 0
      max_count = 27

      vm_size = "Standard_D8as_v5"

      os_disk_type = "Managed"

      os_disk_size_gb = 50

      max_pods = 110


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
      name = "lsspot"
      priority = "Spot"
      enable_auto_scaling = true
      availability_zones = ["1", "2", "3"]

      node_count = null
      min_count = 0
      max_count = 27

      spot_max_price = -1
      eviction_policy = "Delete"

      vm_size = "Standard_D8as_v5"

      os_disk_type = "Managed"

      os_disk_size_gb = 50

      max_pods = 110


      node_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "large-sustained-spot"
      }
      node_taints = [
        "plural.sh/capacityType=SPOT:NoSchedule"
      ]
      tags = {
        "ScalingGroup": "large-sustained-spot"
      }
    }
  ]
}
