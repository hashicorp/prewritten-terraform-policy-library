# Copyright IBM Corp. 2026

# WAF.6 - AWS WAF Classic global rules should have at least one condition.

policy {}

resource_policy "aws_waf_rule" "has_conditions" {
    enforce {
        condition = core::length(core::try(attrs.predicates, [])) > 0
        error_message = "WAF rule does not have any conditions (predicates). Add at least one predicate to enable traffic inspection. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/waf-controls.html#waf-6 for more details."
    }
}
