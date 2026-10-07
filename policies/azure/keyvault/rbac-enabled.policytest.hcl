# Copyright IBM Corp. 2026

policytest {
  targets = ["rbac-enabled.policy.hcl"]
}

resource "azurerm_key_vault" "rbac_enabled" {
  attrs = {
    name                       = "kv-rbac-enabled"
    location                   = "eastus"
    resource_group_name        = "rg-security"
    sku_name                   = "standard"
    tenant_id                  = "11111111-1111-1111-1111-111111111111"
    rbac_authorization_enabled = true
  }
}

resource "azurerm_key_vault" "rbac_disabled" {
  expect_failure = true
  attrs = {
    name                       = "kv-rbac-disabled"
    location                   = "eastus"
    resource_group_name        = "rg-security"
    sku_name                   = "standard"
    tenant_id                  = "22222222-2222-2222-2222-222222222222"
    rbac_authorization_enabled = false
  }
}

resource "azurerm_key_vault" "rbac_absent" {
  expect_failure = true
  attrs = {
    name                = "kv-rbac-absent"
    location            = "eastus"
    resource_group_name = "rg-security"
    sku_name            = "standard"
    tenant_id           = "33333333-3333-3333-3333-333333333333"
  }
}

resource "azurerm_key_vault" "rbac_null" {
  expect_failure = true
  attrs = {
    name                       = "kv-rbac-null"
    location                   = "eastus"
    resource_group_name        = "rg-security"
    sku_name                   = "standard"
    tenant_id                  = "44444444-4444-4444-4444-444444444444"
    rbac_authorization_enabled = null
  }
}
