variable "gcp_project_id" {
  type = string

  description = <<EOF
The ID of the project in which the resources belong.
EOF
}

variable "cluster_name" {
  type = string
  default = "plural"

  description = <<EOF
The name of the cluster, unique within the project and zone.
EOF
}

variable "gcp_region" {
  type = string
  default = "us-east1"

  description = <<EOF
The location (region or zone) in which the cluster master will be created,
as well as the default node location. If you specify a zone (such as
us-central1-a), the cluster will be a zonal cluster with a single cluster
master. If you specify a region (such as us-west1), the cluster will be a
regional cluster with multiple masters spread across zones in that region.
Node pools will also be created as regional or zonal, to match the cluster.
If a node pool is zonal it will have the specified number of nodes in that
zone. If a node pool is regional it will have the specified number of nodes
in each zone within that region. For more information see:
https://cloud.google.com/kubernetes-engine/docs/concepts/regional-clusters
EOF
}

variable "daily_maintenance_window_start_time" {
  type = string
  default = "03:00"

  description = <<EOF
The start time of the 4 hour window for daily maintenance operations RFC3339
format HH:MM, where HH : [00-23] and MM : [00-59] GMT.
EOF
}

variable "node_pools" {
  type = list
  default = [
    {
      name               = "small-burst-on-demand"
      machine_type       = "e2-standard-2"
      min_count          = 1
      max_count          = 9
      disk_size_gb       = 50
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      spot               = false
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 1
      autoscaling        = true
    },
    # {
    #   name               = "small-burst-spot"
    #   machine_type       = "e2-standard-2"
    #   min_count          = 0
    #   max_count          = 9
    #   disk_size_gb       = 50
    #   disk_type          = "pd-standard"
    #   image_type         = "COS_CONTAINERD"
    #   spot               = true
    #   auto_repair        = true
    #   auto_upgrade       = true
    #   preemptible        = false
    #   initial_node_count = 0
    #   autoscaling        = true
    # },
    {
      name               = "medium-burst-on-demand"
      machine_type       = "e2-standard-4"
      min_count          = 0
      max_count          = 9
      disk_size_gb       = 50
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      spot               = false
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 0
      autoscaling        = true
    },
    # {
    #   name               = "medium-burst-spot"
    #   machine_type       = "e2-standard-4"
    #   min_count          = 0
    #   max_count          = 9
    #   disk_size_gb       = 50
    #   disk_type          = "pd-standard"
    #   image_type         = "COS_CONTAINERD"
    #   spot               = true
    #   auto_repair        = true
    #   auto_upgrade       = true
    #   preemptible        = false
    #   initial_node_count = 0
    #   autoscaling        = true
    # },

    {
      name               = "large-burst-on-demand"
      machine_type       = "e2-standard-8"
      min_count          = 0
      max_count          = 9
      disk_size_gb       = 50
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      spot               = false
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 0
      autoscaling        = true
    },
    # {
    #   name               = "large-burst-spot"
    #   machine_type       = "e2-standard-8"
    #   min_count          = 0
    #   max_count          = 9
    #   disk_size_gb       = 50
    #   disk_type          = "pd-standard"
    #   image_type         = "COS_CONTAINERD"
    #   spot               = true
    #   auto_repair        = true
    #   auto_upgrade       = true
    #   preemptible        = false
    #   initial_node_count = 0
    #   autoscaling        = true
    # },
  ]

  description = <<EOF
  The node pools for your cluster
EOF
}

variable "node_pools_labels" {
  type = map(map(string))
  default = {

    all = {}
    "small-burst-on-demand" = {
      "plural.sh/capacityType" = "ON_DEMAND"
      "plural.sh/performanceType" = "BURST"
      "plural.sh/scalingGroup" = "small-burst-on-demand"
    }
    # "small-burst-spot" = {
    #   "plural.sh/capacityType" = "SPOT"
    #   "plural.sh/performanceType" = "BURST"
    #   "plural.sh/scalingGroup" = "small-burst-spot"
    # }
    medium-burst-on-demand = {
      "plural.sh/capacityType" = "ON_DEMAND"
      "plural.sh/performanceType" = "BURST"
      "plural.sh/scalingGroup" = "medium-burst-on-demand"
    }
    # medium-burst-spot = {
    #   "plural.sh/capacityType" = "SPOT"
    #   "plural.sh/performanceType" = "BURST"
    #   "plural.sh/scalingGroup" = "medium-burst-spot"
    # }
    large-burst-on-demand = {
      "plural.sh/capacityType" = "ON_DEMAND"
      "plural.sh/performanceType" = "BURST"
      "plural.sh/scalingGroup" = "large-burst-on-demand"
    }
    # large-burst-spot = {
    #   "plural.sh/capacityType" = "SPOT"
    #   "plural.sh/performanceType" = "BURST"
    #   "plural.sh/scalingGroup" = "large-burst-spot"
    # }
  }
}

variable "node_pools_taints" {
  type = map(list(object({ key = string, value = string, effect = string })))
  default = {
    all = [],
    # small-burst-spot = [
    #   {
    #     key    = "plural.sh/capacityType"
    #     value  = "SPOT"
    #     effect = "NO_SCHEDULE"
    #   },
    # ],
    # meium-burst-spot = [
    #   {
    #     key    = "plural.sh/capacityType"
    #     value  = "SPOT"
    #     effect = "NO_SCHEDULE"
    #   },
    # ],
    # large-burst-spot = [
    #   {
    #     key    = "plural.sh/capacityType"
    #     value  = "SPOT"
    #     effect = "NO_SCHEDULE"
    #   },
    # ]
  }
}

variable "vpc_network_name" {
  type = string
  default = ""

  description = <<EOF
The name of the Google Compute Engine network to which the cluster is
connected.
EOF
}

variable "vpc_name_prefix" {
  type = string
  default = "plural"

  description = <<EOF
Prefix to use for naming vpc networks/subnetworks
EOF
}

variable "vpc_subnetwork_name" {
  type = string
  default = ""

  description = <<EOF
The name of the Google Compute Engine subnetwork in which the cluster's
instances are launched.
EOF
}

variable "k8s_version" {
  type = string
  default = "1.22.7-gke.900"
}

variable "vpc_subnetwork_cidr_range" {
  type = string
  default = "10.0.16.0/20"
}

variable "cluster_secondary_range_cidr" {
  type = string
  default = "10.16.0.0/12"
}

variable "services_secondary_range_cidr" {
  type = string
  default = "10.1.0.0/20"
}

variable "externaldns_sa_name" {
  type = string
  default = "externaldns"
}

variable "access_private_images" {
  type    = string
  default = "false"

  description = <<EOF
Whether to create the IAM role for storage.objectViewer, required to access
GCR for private container images.
EOF
}

variable "http_load_balancing_disabled" {
  type    = string
  default = "false"

  description = <<EOF
The status of the HTTP (L7) load balancing controller addon, which makes it
easy to set up HTTP load balancers for services in a cluster. It is enabled
by default; set disabled = true to disable.
EOF
}

variable "master_authorized_networks_cidr_block" {
  type = string
  default = "0.0.0.0/0"
}

variable "master_authorized_networks_cidr_display" {
  type = string
  default = "default"
}

variable "namespace" {
  type = string
  description = "the namespace for the bootstrap app to live in"
  default = "bootstrap"
}

variable "firewall_inbound_ports" {
  type        = list(string)
  description = "List of TCP ports for admission/webhook controllers"
  default     = ["8443", "9443", "15017"]
}

variable "network_policy_enabled" {
  type = bool
  default = false
  description = "Enable network policy addon. Cannot be used with ADVANCED_DATAPATH."
}

variable "datapath_provider" {
  type        = string
  description = "The desired datapath provider for this cluster. By default, `DATAPATH_PROVIDER_UNSPECIFIED` enables the IPTables-based kube-proxy implementation. `ADVANCED_DATAPATH` enables Dataplane-V2 feature."
  default     = "ADVANCED_DATAPATH"
}
