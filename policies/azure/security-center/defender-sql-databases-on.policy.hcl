# Copyright IBM Corp. 2026

# Ensure That Microsoft Defender for Azure SQL Databases Is Set to 'On'

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "defender-sql-databases-on-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_security_center_subscription_pricing" "sql_databases_defender_on" {
    filter = core::try(attrs.resource_type, "") == "SqlServers"

    locals {
        tier_raw = core::try(attrs.tier, null)
        tier     = local.tier_raw == null ? "" : local.tier_raw
    }

    enforcement_level = input.defender-sql-databases-on-enforcement-level

    enforce {
        condition     = local.tier == "Standard"
        error_message = "Microsoft Defender for Azure SQL Databases must be enabled: azurerm_security_center_subscription_pricing for the 'SqlServers' plan must set tier to 'Standard' (found: '${local.tier}')."
    }
}
