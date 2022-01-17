terraform {
  required_providers {
    metal = {
      source  = "equinix/metal"
      version = ">= 2.1, <4"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.3.0"
    }
  }
  required_version = ">= 0.14"
}
