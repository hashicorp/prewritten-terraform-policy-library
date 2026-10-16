# Copyright IBM Corp. 2026

# Ensure 'Additional email addresses' is Configured with a Security Contact Email

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "security-center-contact-email-configured-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_security_center_contact" "security_contact_email_configured" {
  locals {
    email_raw     = core::try(attrs.email, null)
    email         = local.email_raw == null ? "" : local.email_raw
    entries       = [for entry in core::split(",", local.email) : entry]
    valid_entries = [for entry in local.entries : core::try(core::regex("^\\s*[^@\\s,]+@[^@\\s,]+\\.[^@\\s,]+\\s*$", entry), null) != null]
    invalid_count = core::length([for valid in local.valid_entries : valid if !valid])
    is_valid      = core::try(core::regex("\\S", local.email), null) != null && local.invalid_count == 0
  }

  enforcement_level = input.security-center-contact-email-configured-enforcement-level
  enforce {
    condition     = local.is_valid
    error_message = "The Microsoft Defender for Cloud security contact must include one or more valid email addresses (comma-separated)."
  }
}
