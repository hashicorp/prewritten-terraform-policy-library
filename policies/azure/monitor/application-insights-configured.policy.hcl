# Copyright IBM Corp. 2026

# Ensure that Application Insights Uses a Log Analytics Workspace

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "application-insights-configured-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_application_insights" "application_insights_workspace_configured" {
  enforcement_level = input.application-insights-configured-enforcement-level

  locals {
    workspace_id = core::try(core::lower(core::trimspace(attrs.workspace_id)), null)
    workspace_reference_valid = local.workspace_id == null ? true : core::try(
      core::regex("^/subscriptions/[^/]+/resourcegroups/[^/]+/providers/microsoft\\.operationalinsights/workspaces/[^/]+$", local.workspace_id),
      null
    ) != null
  }

  enforce {
    condition     = local.workspace_reference_valid
    error_message = "The Application Insights component must reference a Log Analytics workspace. Set workspace_id to a workspace resource ID."
  }
}
