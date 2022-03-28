terraform {
  required_providers {
    kind = {
      source  = "kyma-incubator/kind"
      version = ">= 0.0.11, <0.1.0"
    }
  }
  required_version = ">= 0.14"
}
