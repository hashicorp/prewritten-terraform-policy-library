# WAF.7 - AWS WAF Classic global rule groups should have at least one rule.

policy {}

resource_policy "aws_waf_rule_group" "has_rules" {
    locals {
        activated_rules = core::try(attrs.activated_rule, [])
    }

    enforce {
        condition = core::length(local.activated_rules) > 0
        error_message = "WAF rule group has no activated rules. A rule group must have at least one activated rule to ensure proper traffic inspection. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/waf-controls.html#waf-7 for more details."
    }
}
