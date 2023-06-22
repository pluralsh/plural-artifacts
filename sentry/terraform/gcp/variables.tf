variable "cluster_name" {
  type    = string
  default = "plural"
}

variable "namespace" {
  type    = string
  default = "sentry"
}

variable "gcp_region" {
  type        = string
  default     = "us-east1"
  description = <<EOF
The region you wish to deploy to
EOF
}

variable "bucket_location" {
  type        = string
  default     = "US"
  description = "the location of the bucket"
}

variable "project_id" {
  type        = string
  description = <<EOF
The ID of the project in which the resources belong.
EOF
}

variable "filestore_bucket" {
  type = string
}

variable "sentry_serviceaccount_suffixes" {
  type = list(string)
  default = [
    "worker",
    "web",
    "snuba",
    "symbolicator-api",
    "cron",
    "relay",
    "billing-metrics-consumer",
    "ingest-consumer",
    "ingest-metrics-consumer-perf",
    "ingest-metrics-consumer-rh",
    "ingest-replay-recordings",
    "post-process-forwarder-errors",
    "post-process-forwarder-transactions",
    "subscription-consumer-events",
    "subscription-consumer-transactions",
  ]
  description = "suffixes for the k8s service accounts used by sentry"
}
