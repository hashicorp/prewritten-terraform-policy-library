# AWS WAF Classic Regional rules should have at least one condition

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks whether an AWS WAF Regional rule has at least one condition. The control fails if no conditions are present within a rule.

A WAF Regional rule can contain multiple conditions. The rule's conditions allow for traffic inspection and take a defined action (allow, block, or count). Without any conditions, the traffic passes without inspection. A WAF Regional rule with no conditions, but with a name or tag suggesting allow, block, or count, could lead to the wrong assumption that one of those actions is occurring.

This rule is covered by the [waf-regional-rule-not-empty](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/waf/waf-regional-rule-not-empty.policy.hcl) policy.

## Policy Results

```bash
trace:
      # waf-regional-rule-not-empty.policytest.hcl... running
      # resource.aws_wafregional_rule.single_predicate_pass... running
      # resource.aws_wafregional_rule.single_predicate_pass... pass
      # resource.aws_wafregional_rule.multiple_predicates_pass... running
      # resource.aws_wafregional_rule.multiple_predicates_pass... pass
      # resource.aws_wafregional_rule.empty_predicates_fail... running
      # resource.aws_wafregional_rule.empty_predicates_fail... pass
      # resource.aws_wafregional_rule.missing_predicates_fail... running
      # resource.aws_wafregional_rule.missing_predicates_fail... pass
      # waf-regional-rule-not-empty.policytest.hcl... pass
```

---
