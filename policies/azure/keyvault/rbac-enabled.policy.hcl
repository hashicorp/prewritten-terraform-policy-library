# Copyright IBM Corp. 2026

# Ensure Azure Key Vault Uses the Azure RBAC Permission Model

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 5.7.0, < 6.0.0"
    }
  }
}

input "rbac-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_key_vault" "rbac_authorization_enabled" {
    enforcement_level = input.rbac-enabled-enforcement-level

    locals {
        rbac_enabled = core::try(attrs.rbac_authorization_enabled, false) == true
    }

    enforce {
        condition     = local.rbac_enabled
        error_message = "Key Vault must use the Azure RBAC permission model by setting rbac_authorization_enabled to true."
    }
}
