variable "namespace" {
  type    = string
  default = "yatai-system"
}

variable "cluster_name" {
  type = string
}

variable "bucket" {
  type = string
}

variable "role_name" {
  type    = string
  default = "yatai"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = false
  description = "If true, the bucket will be deleted even if it contains objects."
}

variable "yatai_serviceaccount" {
  type    = string
  default = "yatai"
}

variable "yatai_deployment_serviceaccount" {
  type    = string
  default = "yatai-deployment"
}

variable "yatai_image_builder_serviceaccount" {
  type    = string
  default = "yatai-image-builder"
}

######################################## ECR #############################################

variable "use_ecr" {
  description = "Whether to use ECR or not"
  type        = bool
  default     = true
}

variable "repository_type" {
  description = "The type of repository to create. Either `public` or `private`"
  type        = string
  default     = "private"
}

variable "repository_name" {
  description = "The name of the repository"
  type        = string
  default     = "yatai"
}

variable "repository_image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`. Defaults to `IMMUTABLE`"
  type        = string
  default     = "IMMUTABLE"
}

variable "repository_encryption_type" {
  description = "The encryption type for the repository. Must be one of: `KMS` or `AES256`. Defaults to `AES256`"
  type        = string
  default     = null
}

variable "repository_kms_key" {
  description = "The ARN of the KMS key to use when encryption_type is `KMS`. If not specified, uses the default AWS managed key for ECR"
  type        = string
  default     = null
}

variable "repository_image_scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository (`true`) or not scanned (`false`)"
  type        = bool
  default     = false
}

variable "repository_policy" {
  description = "The JSON policy to apply to the repository. If not specified, uses the default policy"
  type        = string
  default     = null
}


variable "attach_repository_policy" {
  description = "Determines whether a repository policy (passed through variable or created by the module) will be attached to the repository"
  type        = bool
  default     = true
}

variable "create_repository_policy" {
  description = "Determines whether a repository policy will be created and if so, it will be attached to the repository"
  type        = bool
  default     = true
}

variable "create_lifecycle_policy" {
  description = "Determines whether a lifecycle policy will be created"
  type        = bool
  default     = false
}

variable "repository_lifecycle_policy" {
  description = "The policy document. This is a JSON formatted string. See more details about [Policy Parameters](http://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html#lifecycle_policy_parameters) in the official AWS docs"
  type        = string
  default     = ""
}

variable "public_repository_catalog_data" {
  description = "Catalog data configuration for the repository"
  type        = any
  default     = {}
}

variable "create_registry_policy" {
  description = "Determines whether a registry policy will be created"
  type        = bool
  default     = false
}

variable "registry_policy" {
  description = "The policy document. This is a JSON formatted string"
  type        = string
  default     = null
}
