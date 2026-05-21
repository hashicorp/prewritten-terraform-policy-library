# WAF.3 - AWS WAF Classic Regional Rule Groups Should Have At Least One Rule

policy {}

resource_policy "aws_wafregional_rule_group" "has_rules" {
    locals {
        activated_rules = core::try(attrs.activated_rule, [])
    }

    enforce {
        condition = core::length(local.activated_rules) > 0
        error_message = "WAF Regional rule group has no activated rules. A rule group must have at least one activated rule to ensure proper traffic inspection. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/waf-controls.html#waf-3 for more details."
    }
}
