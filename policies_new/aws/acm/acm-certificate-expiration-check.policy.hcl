# Copyright IBM Corp. 2026

# Imported and ACM-issued certificates should be renewed after a specified time period

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.33.0, < 7.0.0"
    }
  }
}

input "acm-certificate-expiration-check-enforcement-level" {
  type    = string
  default = "advisory"
}

input "daysToExpiration" {
  type    = number
  default = 14
}

resource_policy "aws_acm_certificate" "certificate_renewal_check" {
  enforcement_level = input.acm-certificate-expiration-check-enforcement-level

  # Configuration: Days before expiration to trigger warning
  # Default: 14 days | Allowed range: 14 to 365 days

  locals {
    days_to_expiration_threshold = input.daysToExpiration

    # Safe access to certificate attributes
    not_after           = core::try(attrs.not_after, null)
    renewal_eligibility = core::try(attrs.renewal_eligibility, null)
    certificate_type    = core::try(attrs.type, null)
    status              = core::try(attrs.status, null)

    # Check if certificate is eligible for automatic renewal
    is_eligible_for_renewal = local.renewal_eligibility == "ELIGIBLE"

    # Check if certificate is in issued state (not pending)
    is_issued = local.status == "ISSUED"

    # Imported certificates have renewal_eligibility == "INELIGIBLE" and require
    # manual renewal — they are exempt from the automatic renewal check
    is_imported = local.certificate_type == "IMPORTED"

    # A certificate needs attention when it is issued, not eligible for automatic
    # renewal, and not an imported certificate that requires manual renewal
    # NOTE: actual days-until-expiry comparison requires core::days_until(local.not_after)
    # which is not yet available in the stdlib. Tracked as a stdlib gap.
    needs_attention = local.is_issued && !local.is_eligible_for_renewal && !local.is_imported
  }

  enforce {
    condition     = !local.needs_attention
    error_message = "ACM certificate requires attention for renewal. Certificate status: ${local.status}, Renewal eligibility: ${local.renewal_eligibility}. The configured daysToExpiration threshold is ${local.days_to_expiration_threshold} days. For DNS-validated certificates, ensure DNS records are properly configured. For email-validated certificates, respond to validation emails. For imported certificates, manual renewal is required before expiration"
  }

  enforce {
    condition     = local.not_after != null
    error_message = "ACM certificate is missing expiration date (not_after attribute). This may indicate the certificate is still being provisioned or has an error. The configured daysToExpiration threshold is ${local.days_to_expiration_threshold} days"
  }
}
