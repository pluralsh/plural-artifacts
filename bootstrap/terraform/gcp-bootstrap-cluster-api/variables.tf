variable "cluster_name" {
  type = string
  default = "plural"
}

variable "namespace" {
  type = string
  description = "the namespace for the bootstrap app to live in"
  default = "bootstrap"
}

variable "gcp_project_id" {
  type = string

  description = <<EOF
The ID of the project in which the resources belong.
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