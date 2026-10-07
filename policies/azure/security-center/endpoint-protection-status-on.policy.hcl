# Copyright IBM Corp. 2026

# Ensure that 'Endpoint protection' Component Status Is Set to 'On'

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "endpoint-protection-status-on-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_security_center_setting" "endpoint_protection_on" {

  locals {
    setting_name_raw = core::try(attrs.setting_name, null)
    setting_name     = local.setting_name_raw == null ? "" : local.setting_name_raw
    in_scope         = core::contains(["WDATP", "WDATP_UNIFIED_SOLUTION"], local.setting_name)

    enabled_raw = core::try(attrs.enabled, null)
    enabled     = local.enabled_raw == null ? false : local.enabled_raw
  }

  filter = local.in_scope

  enforcement_level = input.endpoint-protection-status-on-enforcement-level

  enforce {
    condition     = local.enabled == true
    error_message = "Endpoint protection (setting_name WDATP / WDATP_UNIFIED_SOLUTION) must be enabled=true."
  }
}
