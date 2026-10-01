# Copyright IBM Corp. 2026

# Ensure that Defender for Servers Is Set to 'On'

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "defender-servers-on-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_security_center_subscription_pricing" "defender_for_servers_on" {
  locals {
    resource_type_raw = core::try(attrs.resource_type, null)
    resource_type = local.resource_type_raw == null ? "VirtualMachines" : local.resource_type_raw
    tier_raw      = core::try(attrs.tier, null)
  }

  filter = local.resource_type == "VirtualMachines"

  enforcement_level = input.defender-servers-on-enforcement-level

  enforce {
    condition     = local.tier_raw == "Standard"
    error_message = "Defender for Servers must be On: azurerm_security_center_subscription_pricing for resource_type=VirtualMachines must set tier = \"Standard\"."
  }
}
