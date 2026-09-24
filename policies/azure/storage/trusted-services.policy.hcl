# Copyright IBM Corp. 2026

# Ensure 'Allow trusted Microsoft services to access this resource' is Enabled for Storage Account Access

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "trusted-services-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_storage_account" "allow_trusted_microsoft_services" {
  locals {
    public_network_access_enabled_raw = core::try(attrs.public_network_access_enabled, null)
    public_network_access_enabled     = local.public_network_access_enabled_raw != null ? local.public_network_access_enabled_raw : true

    # network_rules is a list-typed block. An explicitly empty list (`network_rules = []`)
    # is not null, so a bare null check is not enough to guard the [0] index below —
    # coalesce to [] and test the length, otherwise indexing an empty list aborts
    # policy evaluation. Note tfpolicy's && does NOT short-circuit, so the null must be
    # removed before core::length sees it rather than guarded by a preceding condition.
    inline_rules_raw     = core::try(attrs.network_rules, null)
    inline_rules         = local.inline_rules_raw != null ? local.inline_rules_raw : []
    has_inline_rules     = core::length(local.inline_rules) > 0
    inline_rule          = local.has_inline_rules ? local.inline_rules[0] : null
    inline_default_raw   = core::try(local.inline_rule.default_action, null)
    inline_default       = local.inline_default_raw != null ? local.inline_default_raw : ""
    inline_bypass_raw    = core::try(local.inline_rule.bypass, null)
    inline_bypass        = local.inline_bypass_raw != null ? local.inline_bypass_raw : []

    standalone_id_raw     = core::try(attrs.id, null)
    standalone_rules      = local.standalone_id_raw != null ? core::getresources("azurerm_storage_account_network_rules", { storage_account_id = local.standalone_id_raw }) : []
    standalone_deny_rules = [for r in local.standalone_rules : r if core::try(r.default_action, "") == "Deny"]
    standalone_in_scope   = local.public_network_access_enabled && core::length(local.standalone_deny_rules) > 0
    standalone_rules_trusted_services = core::length(local.standalone_deny_rules) > 0 && core::length([
      for r in local.standalone_deny_rules : r
      if core::contains(core::try(r.bypass, null) != null ? r.bypass : [], "AzureServices")
    ]) == core::length(local.standalone_deny_rules)

    inline_in_scope  = local.public_network_access_enabled && local.has_inline_rules && local.inline_default == "Deny"
    in_scope         = local.inline_in_scope || local.standalone_in_scope
    inline_trusted_services      = !local.inline_in_scope || core::contains(local.inline_bypass, "AzureServices")
    standalone_trusted_services  = !local.standalone_in_scope || local.standalone_rules_trusted_services
    trusted_services              = local.inline_trusted_services && local.standalone_trusted_services
  }

  enforcement_level = input.trusted-services-enforcement-level
  enforce {
    condition     = !local.in_scope || local.trusted_services
    error_message = "Storage account network rules have a default action of Deny but 'AzureServices' is not included in the bypass list."
  }
}

resource_policy "azurerm_storage_account_network_rules" "allow_trusted_microsoft_services" {
  locals {
    default_action = core::try(attrs.default_action, "")
    bypass_raw     = core::try(attrs.bypass, null)
    bypass         = local.bypass_raw != null ? local.bypass_raw : []
    in_scope       = local.default_action == "Deny"
  }

  enforcement_level = input.trusted-services-enforcement-level
  enforce {
    condition     = !local.in_scope || core::contains(local.bypass, "AzureServices")
    error_message = "Storage account network rules with a default action of Deny must include AzureServices in the bypass list."
  }
}
