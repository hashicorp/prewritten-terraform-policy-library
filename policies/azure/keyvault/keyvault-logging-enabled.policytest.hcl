# Copyright IBM Corp. 2026

policytest {
  targets = ["keyvault-logging-enabled.policy.hcl"]
}

resource "azurerm_key_vault" "pass_audit_alllogs_storage" {
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-pass-storage"
    name                = "kv-pass-storage"
    location            = "eastus"
    resource_group_name = "rg"
    tenant_id           = "00000000-0000-0000-0000-000000000000"
    sku_name            = "standard"
  }
}

resource "azurerm_monitor_diagnostic_setting" "diag_pass_storage" {
  skip = true
  attrs = {
    name               = "diag-pass-storage"
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-pass-storage"
    storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/logacct1"
    enabled_log = [
      { category_group = "audit" },
      { category_group = "allLogs" }
    ]
  }
}

resource "azurerm_key_vault" "pass_audit_alllogs_law" {
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-pass-law"
    name                = "kv-pass-law"
    location            = "eastus"
    resource_group_name = "rg"
    tenant_id           = "00000000-0000-0000-0000-000000000000"
    sku_name            = "standard"
  }
}

resource "azurerm_monitor_diagnostic_setting" "diag_pass_law" {
  skip = true
  attrs = {
    name               = "diag-pass-law"
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-pass-law"
    log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.OperationalInsights/workspaces/law1"
    enabled_log = [
      { category_group = "audit" },
      { category_group = "allLogs" }
    ]
  }
}

resource "azurerm_key_vault" "pass_auditevent_category" {
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-pass-auditevent"
    name                = "kv-pass-auditevent"
    location            = "eastus"
    resource_group_name = "rg"
    tenant_id           = "00000000-0000-0000-0000-000000000000"
    sku_name            = "standard"
  }
}

resource "azurerm_monitor_diagnostic_setting" "diag_pass_auditevent" {
  skip = true
  attrs = {
    name               = "diag-pass-auditevent"
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-pass-auditevent"
    log_analytics_workspace_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.OperationalInsights/workspaces/law1"
    enabled_log = [
      { category = "AuditEvent" },
      { category_group = "allLogs" }
    ]
  }
}

resource "azurerm_key_vault" "fail_no_diagnostic_setting" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-fail-no-setting"
    name                = "kv-fail-no-setting"
    location            = "eastus"
    resource_group_name = "rg"
    tenant_id           = "00000000-0000-0000-0000-000000000000"
    sku_name            = "standard"
  }
}

resource "azurerm_key_vault" "fail_empty_logs" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-fail-empty"
    name                = "kv-fail-empty"
    location            = "eastus"
    resource_group_name = "rg"
    tenant_id           = "00000000-0000-0000-0000-000000000000"
    sku_name            = "standard"
  }
}

resource "azurerm_monitor_diagnostic_setting" "diag_fail_empty" {
  skip = true
  attrs = {
    name               = "diag-fail-empty"
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-fail-empty"
    storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/logacct1"
    enabled_log        = []
  }
}

resource "azurerm_key_vault" "fail_missing_alllogs" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-fail-missing-alllogs"
    name                = "kv-fail-missing-alllogs"
    location            = "eastus"
    resource_group_name = "rg"
    tenant_id           = "00000000-0000-0000-0000-000000000000"
    sku_name            = "standard"
  }
}

resource "azurerm_monitor_diagnostic_setting" "diag_fail_missing_alllogs" {
  skip = true
  attrs = {
    name               = "diag-fail-missing-alllogs"
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-fail-missing-alllogs"
    storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/logacct1"
    enabled_log = [
      { category_group = "audit" }
    ]
  }
}

resource "azurerm_key_vault" "fail_missing_audit" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-fail-missing-audit"
    name                = "kv-fail-missing-audit"
    location            = "eastus"
    resource_group_name = "rg"
    tenant_id           = "00000000-0000-0000-0000-000000000000"
    sku_name            = "standard"
  }
}

resource "azurerm_monitor_diagnostic_setting" "diag_fail_missing_audit" {
  skip = true
  attrs = {
    name               = "diag-fail-missing-audit"
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-fail-missing-audit"
    storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/logacct1"
    enabled_log = [
      { category_group = "allLogs" }
    ]
  }
}

resource "azurerm_key_vault" "fail_no_destination" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-fail-no-dest"
    name                = "kv-fail-no-dest"
    location            = "eastus"
    resource_group_name = "rg"
    tenant_id           = "00000000-0000-0000-0000-000000000000"
    sku_name            = "standard"
  }
}

resource "azurerm_monitor_diagnostic_setting" "diag_fail_no_dest" {
  skip = true
  attrs = {
    name               = "diag-fail-no-dest"
    target_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-fail-no-dest"
    enabled_log = [
      { category_group = "audit" },
      { category_group = "allLogs" }
    ]
  }
}

resource "azurerm_key_vault" "fail_setting_for_other_vault" {
  expect_failure = true
  attrs = {
    id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-fail-other"
    name                = "kv-fail-other"
    location            = "eastus"
    resource_group_name = "rg"
    tenant_id           = "00000000-0000-0000-0000-000000000000"
    sku_name            = "standard"
  }
}
