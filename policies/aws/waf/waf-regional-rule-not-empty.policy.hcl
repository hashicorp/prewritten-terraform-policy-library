# Copyright IBM Corp. 2026

# WAF.2 - AWS WAF Classic Regional rules should have at least one condition.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, < 7.0.0"
    }
  }
}

input "waf-regional-rule-not-empty-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_wafregional_rule" "requires_at_least_one_predicate" {
    enforcement_level = input.waf-regional-rule-not-empty-enforcement-level
    locals {
        predicates = core::try(attrs.predicate, [])
    }

    enforce {
        condition = core::length(local.predicates) > 0
        error_message = "AWS WAF Regional rule must define at least one predicate (condition). Add one or more predicate blocks to the aws_wafregional_rule resource. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/waf-controls.html#waf-2 for more details."
    }
}
