# Copyright IBM Corp. 2026

# OpenSearch domains should have audit logging enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9.0, < 7.0.0"
    }
  }
}

input "opensearch-audit-logging-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_opensearch_domain" "audit_logging_enabled" {
  enforcement_level = input.opensearch-audit-logging-enabled-enforcement-level
  locals {
    log_options     = core::try([for opt in attrs.log_publishing_options : opt], [])
    has_log_options = core::length(local.log_options) > 0

    non_audit_options = [
      for opt in local.log_options : opt
      if !(core::try(opt.enabled, false) == true && core::try(opt.log_type, "") == "AUDIT_LOGS")
    ]

    is_compliant = local.has_log_options && core::length(local.non_audit_options) == 0
  }

  enforce {
    condition     = local.is_compliant
    error_message = "Attribute 'enabled' in 'log_publishing_options' should be true and 'log_type' set to 'AUDIT_LOGS' for AWS OpenSearch Domain."
  }
}
