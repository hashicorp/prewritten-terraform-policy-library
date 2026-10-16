# Copyright IBM Corp. 2026

# Ensure that Microsoft Defender CSPM is Enabled

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "security-center-defender-cspm-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_security_center_subscription_pricing" "defender_cspm_on" {
  locals {
    resource_type_raw = core::try(attrs.resource_type, null)
    resource_type     = local.resource_type_raw == null ? "VirtualMachines" : local.resource_type_raw
    tier_raw          = core::try(attrs.tier, null)
    tier              = local.tier_raw == null ? "" : local.tier_raw
  }

  filter = local.resource_type == "CloudPosture"

  enforcement_level = input.security-center-defender-cspm-enabled-enforcement-level
  enforce {
    condition     = core::lower(local.tier) == "standard"
    error_message = "Microsoft Defender CSPM (CloudPosture) must be enabled with pricing tier Standard."
  }
}
