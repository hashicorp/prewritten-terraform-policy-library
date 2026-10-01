# Copyright IBM Corp. 2026

# Ensure that Logging for Azure Key Vault is Enabled

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "keyvault-logging-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  keyvault_diagnostic_settings = core::getresources("azurerm_monitor_diagnostic_setting", {})
}

resource_policy "azurerm_key_vault" "keyvault_logging_enabled" {
  enforcement_level = input.keyvault-logging-enabled-enforcement-level

  locals {
    vault_id_raw = core::try(attrs.id, null)
    vault_id     = local.vault_id_raw == null ? "" : local.vault_id_raw

    matching_settings = [
      for setting in local.keyvault_diagnostic_settings : setting
      if local.vault_id != "" &&
      core::lower(core::try(setting.target_resource_id, "")) == core::lower(local.vault_id)
    ]

    qualifying_settings = [
      for setting in local.matching_settings : setting
      if(
        core::try(core::regex("\\S", core::try(setting.storage_account_id, "")), null) != null ||
        core::try(core::regex("\\S", core::try(setting.log_analytics_workspace_id, "")), null) != null ||
        core::try(core::regex("\\S", core::try(setting.eventhub_authorization_rule_id, "")), null) != null ||
        core::try(core::regex("\\S", core::try(setting.partner_solution_id, "")), null) != null
        ) && core::length([
          for log in core::try([for item in setting.enabled_log : item], []) : log
          if core::try(log.category, null) == "AuditEvent" || core::try(log.category_group, null) == "audit"
        ]) > 0 && core::length([
          for log in core::try([for item in setting.enabled_log : item], []) : log
          if core::try(log.category_group, null) == "allLogs"
      ]) > 0
    ]
  }

  enforce {
    condition     = core::length(local.qualifying_settings) > 0
    error_message = "Key Vault must have a diagnostic setting that sends logs to a configured destination and enables both the 'audit' (AuditEvent) and 'allLogs' category groups via enabled_log."
  }
}
