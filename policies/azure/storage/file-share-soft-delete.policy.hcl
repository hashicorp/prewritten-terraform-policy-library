# Copyright IBM Corp. 2026

# Ensure Soft Delete for Azure File Shares is Enabled

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

resource_policy "azurerm_storage_account" "file_share_soft_delete" {
  locals {
    share_properties_raw = core::try(attrs.share_properties, null)
    share_properties     = local.share_properties_raw != null ? local.share_properties_raw : []
    retention_policy_raw = core::try(local.share_properties[0].retention_policy, null)
    retention_policy     = local.retention_policy_raw != null ? local.retention_policy_raw : []
    retention_days_raw   = core::try(local.retention_policy[0].days, null)
    retention_days       = local.retention_days_raw != null ? local.retention_days_raw : 0
    retention_configured = core::length(local.retention_policy) > 0 && local.retention_days_raw != null
    retention_in_range   = local.retention_configured && local.retention_days >= 1 && local.retention_days <= 365
  }

  enforcement_level = "advisory"
  enforce {
    condition     = local.retention_in_range
    error_message = "Azure Storage Accounts must enable file-share soft delete by configuring share_properties.retention_policy.days between 1 and 365 days."
  }
}
