# Copyright IBM Corp. 2026

# Ensure Certificate 'Validity Period (in months)' is Less Than or Equal to '12'

policy {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 6.0.0"
    }
  }
}

input "certificate-validity-12-months-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "azurerm_key_vault_certificate" "validity_period_max_12_months" {
  enforcement_level = input.certificate-validity-12-months-enforcement-level

  locals {
    validity_raw = core::try(attrs.certificate_policy[0].x509_certificate_properties[0].validity_in_months, null)
    validity_in_months = local.validity_raw == null ? 12 : local.validity_raw
  }

  enforce {
    condition     = local.validity_in_months <= 12
    error_message = "Key Vault certificate issuance policy validity_in_months must be <= 12 (got ${local.validity_in_months})."
  }
}
