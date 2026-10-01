# Copyright IBM Corp. 2026

# Ensure That Microsoft Defender for SQL Servers on Machines Is Set to 'On'

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "defender-sql-servers-on-machines-on-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_security_center_subscription_pricing" "defender_for_sql_on_machines_on" {
  filter = core::try(attrs.resource_type, "") == "SqlServerVirtualMachines"

  locals {
    tier_raw = core::try(attrs.tier, null)
    tier     = local.tier_raw == null ? "" : local.tier_raw
  }

  enforcement_level = input.defender-sql-servers-on-machines-on-enforcement-level

  enforce {
    condition     = local.tier == "Standard"
    error_message = "Microsoft Defender for SQL servers on machines must be set to 'On': azurerm_security_center_subscription_pricing for resource_type 'SqlServerVirtualMachines' must have tier = 'Standard' (found: '${local.tier}')."
  }
}
