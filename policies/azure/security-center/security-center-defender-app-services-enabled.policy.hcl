# Copyright IBM Corp. 2026

# Ensure That Microsoft Defender for App Services Is Set To 'On'

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "security-center-defender-app-services-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_security_center_subscription_pricing" "defender_app_service_on" {
  filter = core::try(attrs.resource_type, null) == "AppServices"

  locals {
    tier_raw = core::try(attrs.tier, null)
  }

  enforcement_level = input.security-center-defender-app-services-enabled-enforcement-level

  enforce {
    condition     = local.tier_raw == "Standard"
    error_message = "Microsoft Defender for App Service must be enabled: azurerm_security_center_subscription_pricing for resource_type 'AppServices' must set tier = 'Standard'."
  }
}
