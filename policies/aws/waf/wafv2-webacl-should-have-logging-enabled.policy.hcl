# Copyright IBM Corp. 2026

# AWS WAF web ACL logging should be enabled
policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "wafv2-webacl-should-have-logging-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_wafv2_web_acl" "logging_enabled" {
  locals {
    web_acl_arn     = core::try(attrs.arn, null)
    logging_configs = local.web_acl_arn == null ? [] : core::getresources("aws_wafv2_web_acl_logging_configuration", {
      resource_arn = local.web_acl_arn
    })
  }

  enforcement_level = input.wafv2-webacl-should-have-logging-enabled-enforcement-level
  enforce {
    condition     = core::length(local.logging_configs) > 0
    error_message = "WAFv2 Web ACLs should have logging enabled. Add an aws_wafv2_web_acl_logging_configuration whose resource_arn references this web ACL."
  }
}

