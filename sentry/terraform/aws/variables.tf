variable "cluster_name" {
  type    = string
  default = "plural"
}

variable "namespace" {
  type    = string
  default = "sentry"
}

variable "sentry_serviceaccount" {
  type        = string
  default     = "sentry"
  description = "name of the k8s service account for sentry"
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
    "ingest-consumer-attachments",
    "ingest-consumer-events",
    "ingest-consumer-transactions",
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

variable "filestore_bucket" {
  type = string
}

variable "role_name" {
  type        = string
  default     = "sentry"
  description = "name of the IAM role for sentry to assume"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = true
  description = "If true, the bucket will be deleted even if it contains objects."
}
