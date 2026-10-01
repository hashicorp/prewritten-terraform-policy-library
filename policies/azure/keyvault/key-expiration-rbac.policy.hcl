# Copyright IBM Corp. 2026

# Ensure that the Expiration Date is Set for All Keys in Key Vaults Using RBAC

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 5.7.0, < 6.0.0"
    }
  }
}

input "key-expiration-rbac-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_key_vault_key" "expiration_date_set" {
  enforcement_level = input.key-expiration-rbac-enforcement-level

  locals {
    vault_id      = core::try(attrs.key_vault_id, null)
    parent_vaults = local.vault_id == null ? [] : core::getresources("azurerm_key_vault", { id = local.vault_id })
    vault_found   = core::length(local.parent_vaults) > 0

    vault_uses_rbac = local.vault_found && core::try(local.parent_vaults[0].rbac_authorization_enabled, null) == true

    expiration_raw = core::try(attrs.expiration_date, null)
    expiration     = local.expiration_raw == null ? "" : local.expiration_raw
    has_expiration = core::try(core::regex("\\S", local.expiration), null) != null
  }

  filter = local.vault_uses_rbac

  enforce {
    condition     = local.has_expiration
    error_message = "Key Vault key in a vault using Azure RBAC must have a non-empty expiration_date set; by default keys never expire."
  }
}
