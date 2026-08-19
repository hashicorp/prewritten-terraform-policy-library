# Copyright IBM Corp. 2026

policytest {
  targets = ["blob-soft-delete.policy.hcl"]
}

resource "azurerm_storage_account" "pass_provider_default_days" {
  attrs = {
    name                     = "defaultdaysstorageacct"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    blob_properties = {
      delete_retention_policy = {}
    }
  }
}

resource "azurerm_storage_account" "pass_lower_boundary" {
  attrs = {
    name                     = "lowerboundstorageacct"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    blob_properties = {
      delete_retention_policy = {
        days = 1
      }
    }
  }
}

resource "azurerm_storage_account" "pass_upper_boundary" {
  attrs = {
    name                     = "upperboundstorageacct"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    blob_properties = {
      delete_retention_policy = {
        days = 365
      }
    }
  }
}

resource "azurerm_storage_account" "fail_missing_blob_properties" {
  expect_failure = true
  attrs = {
    name                     = "missingblobstorageacct"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
  }
}

resource "azurerm_storage_account" "fail_null_blob_properties" {
  expect_failure = true
  attrs = {
    name                     = "nullblobstorageacct"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    blob_properties          = null
  }
}

resource "azurerm_storage_account" "fail_missing_delete_retention_policy" {
  expect_failure = true
  attrs = {
    name                     = "missingpolicystorageacct"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    blob_properties          = {}
  }
}

resource "azurerm_storage_account" "fail_below_retention_range" {
  expect_failure = true
  attrs = {
    name                     = "belowrangestorageacct"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    blob_properties = {
      delete_retention_policy = {
        days = 0
      }
    }
  }
}

resource "azurerm_storage_account" "fail_above_retention_range" {
  expect_failure = true
  attrs = {
    name                     = "aboverangestorageacct"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "StorageV2"
    blob_properties = {
      delete_retention_policy = {
        days = 366
      }
    }
  }
}

resource "azurerm_storage_account" "fail_storage_v1_without_blob_properties" {
  expect_failure = true
  attrs = {
    name                     = "storagevoneaccount"
    resource_group_name      = "validation-resource-group"
    location                 = "eastus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    account_kind             = "Storage"
  }
}
