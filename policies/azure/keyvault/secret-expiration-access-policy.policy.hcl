# Copyright IBM Corp. 2026

# Ensure that the Expiration Date is Set for All Secrets in Key Vaults Using Access Policies

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 5.7.0, < 6.0.0"
    }
  }
}

input "secret-expiration-access-policy-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_key_vault_secret" "expiration_date_set_access_policy" {
  enforcement_level = input.secret-expiration-access-policy-enforcement-level

  locals {
    vault_id      = core::try(attrs.key_vault_id, null)
    parent_vaults = local.vault_id == null ? [] : core::getresources("azurerm_key_vault", { id = local.vault_id })
    vault_found   = core::length(local.parent_vaults) > 0

    vault_uses_rbac = local.vault_found && core::try(local.parent_vaults[0].rbac_authorization_enabled, null) == true

    expiration_raw = core::try(attrs.expiration_date, null)
    expiration     = local.expiration_raw == null ? "" : local.expiration_raw
    has_expiration = core::try(core::regex("\\S", local.expiration), null) != null
  }

  filter = local.vault_found && !local.vault_uses_rbac

  enforce {
    condition     = local.has_expiration
    error_message = "Key Vault secret in a vault using access policies must have a non-empty expiration_date set; by default secrets never expire."
  }
}
