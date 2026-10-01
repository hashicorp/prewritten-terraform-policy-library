# Copyright IBM Corp. 2026

policytest {
  targets = ["secret-expiration-access-policy.policy.hcl"]
}

resource "azurerm_key_vault" "rbac_vault" {
  skip = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/kv-rg/providers/Microsoft.KeyVault/vaults/kv-rbac"
    name                = "kv-rbac"
    location            = "eastus"
    resource_group_name = "kv-rg"
    tenant_id           = "00000000-0000-0000-0000-000000000000"
    sku_name            = "standard"
    rbac_authorization_enabled = true
  }
}

resource "azurerm_key_vault" "inline_ap_vault" {
  skip = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/kv-rg/providers/Microsoft.KeyVault/vaults/kv-inline-ap"
    name                = "kv-inline-ap"
    location            = "eastus"
    resource_group_name = "kv-rg"
    tenant_id           = "00000000-0000-0000-0000-000000000000"
    sku_name            = "standard"
    rbac_authorization_enabled = false
    access_policy = [{
      tenant_id          = "00000000-0000-0000-0000-000000000000"
      object_id          = "00000000-0000-0000-0000-000000000001"
      key_permissions    = ["Get"]
      secret_permissions = ["Get"]
    }]
  }
}

resource "azurerm_key_vault" "standalone_ap_vault" {
  skip = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/kv-rg/providers/Microsoft.KeyVault/vaults/kv-standalone-ap"
    name                = "kv-standalone-ap"
    location            = "eastus"
    resource_group_name = "kv-rg"
    tenant_id           = "00000000-0000-0000-0000-000000000000"
    sku_name            = "standard"
    rbac_authorization_enabled = false
  }
}

resource "azurerm_key_vault_access_policy" "standalone_ap" {
  skip = true
  attrs = {
    key_vault_id       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/kv-rg/providers/Microsoft.KeyVault/vaults/kv-standalone-ap"
    tenant_id          = "00000000-0000-0000-0000-000000000000"
    object_id          = "00000000-0000-0000-0000-000000000002"
    key_permissions    = ["Get"]
    secret_permissions = ["Get"]
  }
}

resource "azurerm_key_vault_secret" "pass_inline_ap_with_expiration" {
  attrs = {
    name            = "pass-inline-ap-with-expiration"
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/kv-rg/providers/Microsoft.KeyVault/vaults/kv-inline-ap"
    value           = "s3cr3t"
    expiration_date = "2030-12-31T23:59:59Z"
  }
}

resource "azurerm_key_vault_secret" "fail_inline_ap_expiration_absent" {
  expect_failure = true
  attrs = {
    name            = "fail-inline-ap-expiration-absent"
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/kv-rg/providers/Microsoft.KeyVault/vaults/kv-inline-ap"
    value           = "s3cr3t"
  }
}

resource "azurerm_key_vault_secret" "pass_standalone_ap_with_expiration" {
  attrs = {
    name            = "pass-standalone-ap-with-expiration"
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/kv-rg/providers/Microsoft.KeyVault/vaults/kv-standalone-ap"
    value           = "s3cr3t"
    expiration_date = "2030-12-31T23:59:59Z"
  }
}

resource "azurerm_key_vault_secret" "fail_standalone_ap_expiration_absent" {
  expect_failure = true
  attrs = {
    name            = "fail-standalone-ap-expiration-absent"
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/kv-rg/providers/Microsoft.KeyVault/vaults/kv-standalone-ap"
    value           = "s3cr3t"
  }
}

resource "azurerm_key_vault_secret" "fail_inline_ap_expiration_null" {
  expect_failure = true
  attrs = {
    name            = "fail-inline-ap-expiration-null"
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/kv-rg/providers/Microsoft.KeyVault/vaults/kv-inline-ap"
    value           = "s3cr3t"
    expiration_date = null
  }
}

resource "azurerm_key_vault_secret" "fail_inline_ap_expiration_empty" {
  expect_failure = true
  attrs = {
    name            = "fail-inline-ap-expiration-empty"
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/kv-rg/providers/Microsoft.KeyVault/vaults/kv-inline-ap"
    value           = "s3cr3t"
    expiration_date = ""
  }
}

resource "azurerm_key_vault_secret" "fail_inline_ap_expiration_whitespace" {
  expect_failure = true
  attrs = {
    name            = "fail-inline-ap-expiration-whitespace"
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/kv-rg/providers/Microsoft.KeyVault/vaults/kv-inline-ap"
    value           = "s3cr3t"
    expiration_date = "   "
  }
}

resource "azurerm_key_vault_secret" "skip_rbac_no_expiration" {
  attrs = {
    name            = "skip-rbac-no-expiration"
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/kv-rg/providers/Microsoft.KeyVault/vaults/kv-rbac"
    value           = "s3cr3t"
  }
}

resource "azurerm_key_vault_secret" "skip_vault_not_in_plan_no_expiration" {
  attrs = {
    name            = "skip-vault-not-in-plan-no-expiration"
    key_vault_id    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/kv-rg/providers/Microsoft.KeyVault/vaults/kv-not-in-plan"
    value           = "s3cr3t"
  }
}
