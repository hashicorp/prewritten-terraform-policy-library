# Copyright IBM Corp. 2026

# Ensure Public Network Access is Disabled for Azure Key Vault

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "public-network-access-disabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_key_vault" "public_network_access_disabled" {
    locals {
        public_access_raw = core::try(attrs.public_network_access_enabled, null)
        public_access = local.public_access_raw == null ? true : local.public_access_raw
    }

    enforcement_level = input.public-network-access-disabled-enforcement-level

    enforce {
        condition     = local.public_access == false
        error_message = "Key Vault must have public network access disabled (public_network_access_enabled = false)."
    }
}
