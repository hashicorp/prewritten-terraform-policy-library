# Copyright IBM Corp. 2026

# Ensure That Microsoft Defender for Key Vault Is Set to 'On'

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "defender-keyvault-on-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_security_center_subscription_pricing" "defender_for_key_vault_on" {
    filter = core::try(attrs.resource_type, null) == "KeyVaults"

    locals {
        tier_raw = core::try(attrs.tier, null)
        tier     = local.tier_raw == null ? "" : local.tier_raw
    }

    enforcement_level = input.defender-keyvault-on-enforcement-level

    enforce {
        condition     = local.tier == "Standard"
        error_message = "Microsoft Defender for Key Vault must be enabled: azurerm_security_center_subscription_pricing for resource_type 'KeyVaults' must set tier = \"Standard\" (got \"${local.tier}\")."
    }
}
