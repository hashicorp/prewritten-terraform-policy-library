# Copyright IBM Corp. 2026

# Ensure That Compute Instances Have Confidential Computing Enabled

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

resource_policy "google_compute_instance" "require_confidential_computing" {
  locals {
    confidential_config_raw = core::try(attrs.confidential_instance_config[0], attrs.confidential_instance_config, null)
    confidential_enabled_raw = core::try(
      local.confidential_config_raw.enable_confidential_compute,
      null,
    )
    confidential_enabled = local.confidential_enabled_raw == null ? false : local.confidential_enabled_raw
    is_compliant         = local.confidential_config_raw != null && local.confidential_enabled == true
  }

  enforcement_level = "advisory"
  enforce {
    condition     = local.is_compliant
    error_message = "Compute instances must include confidential_instance_config and explicitly set enable_confidential_compute to true. Recreate the instance with Confidential Computing enabled."
  }
}
