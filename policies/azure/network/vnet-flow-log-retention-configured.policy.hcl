# Copyright IBM Corp. 2026

# Ensure that Virtual Network Flow Logs Retain Data for at Least 90 Days

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.11.0, < 6.0.0"
    }
  }
}

input "vnet-flow-log-retention-configured-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_network_watcher_flow_log" "vnet_flow_log_retention" {
  filter = core::try(
    core::regex("^/subscriptions/[^/]+/resourcegroups/[^/]+/providers/microsoft\\.network/virtualnetworks/[^/]+$", core::lower(core::trimspace(attrs.target_resource_id))),
    null
  ) != null

  enforcement_level = input.vnet-flow-log-retention-configured-enforcement-level

  locals {
    days = core::try(attrs.retention_policy[0].days, null)
    enabled = core::try(attrs.enabled, null)
    retention_enabled = core::try(attrs.retention_policy[0].enabled, null)
    days_ok = local.retention_enabled == false ? true : (local.days == null ? true : (local.days == 0 || local.days >= 90))
  }

  enforce {
    condition     = local.enabled != false
    error_message = "The virtual network flow log must be enabled."
  }

  enforce {
    condition     = local.days_ok
    error_message = "The virtual network flow log must disable retention for indefinite storage or retain data for 0 days (indefinite) or at least 90 days."
  }
}
