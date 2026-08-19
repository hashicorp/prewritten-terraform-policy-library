# Copyright IBM Corp. 2026

# 3.2 Ensure Legacy Networks Do Not Exist for Older Projects (Automated)

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

resource_policy "google_compute_network" "no_legacy_networks" {
  operations = ["create", "update"]

  locals {
    gateway_ipv4_raw = core::try(attrs.gateway_ipv4, null)
    gateway_ipv4     = local.gateway_ipv4_raw != null ? local.gateway_ipv4_raw : ""
  }

  enforcement_level = "advisory"
  enforce {
    condition     = local.gateway_ipv4 == ""
    error_message = "Legacy Google Compute networks are not permitted. Replace this network with an auto-mode or custom-mode VPC network."
  }
}
