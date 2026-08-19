# Copyright IBM Corp. 2026

# Ensure Compute Instances Are Launched With Shielded VM Enabled

policy {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0.0, < 8.0.0"
    }
  }
}

resource_policy "google_compute_instance" "shielded_vm_enabled" {
  locals {
    shielded_config_raw = core::try(attrs.shielded_instance_config[0], attrs.shielded_instance_config, null)
    has_shielded_config = local.shielded_config_raw != null

    vtpm_raw = core::try(local.shielded_config_raw.enable_vtpm, null)
    vtpm     = local.vtpm_raw == null ? false : local.vtpm_raw

    integrity_monitoring_raw = core::try(local.shielded_config_raw.enable_integrity_monitoring, null)
    integrity_monitoring     = local.integrity_monitoring_raw == null ? false : local.integrity_monitoring_raw
  }

  enforcement_level = "advisory"
  enforce {
    condition     = local.has_shielded_config && local.vtpm && local.integrity_monitoring
    error_message = "Compute instances must include shielded_instance_config with enable_vtpm and enable_integrity_monitoring set to true."
  }
}
