# Copyright IBM Corp. 2026

# Ensure 'Purge protection' is Set to 'Enabled' for Azure Key Vault

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "purge-protection-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_key_vault" "purge_protection_enabled" {
    locals {
        purge_protection_raw = core::try(attrs.purge_protection_enabled, null)
        purge_protection = local.purge_protection_raw == null ? false : local.purge_protection_raw
    }

    enforcement_level = input.purge-protection-enabled-enforcement-level

    enforce {
        condition     = local.purge_protection == true
        error_message = "Key vault must have purge protection enabled (purge_protection_enabled = true) to keep the vault and its objects recoverable after deletion."
    }
}
