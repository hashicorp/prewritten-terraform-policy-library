# AWS WAF Classic global rules should have at least one condition

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks whether an AWS WAF global rule contains any conditions. The control fails if no conditions are present within a rule.

A WAF global rule can contain multiple conditions. A rule's conditions allow for traffic inspection and take a defined action (allow, block, or count). Without any conditions, the traffic passes without inspection. A WAF global rule with no conditions, but with a name or tag suggesting allow, block, or count, could lead to the wrong assumption that one of those actions is occurring.

This rule is covered by the [waf-global-rule-not-empty](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/waf/waf-global-rule-not-empty.policy.hcl) policy.

## Policy Results

```bash
trace:
      # waf-global-rule-not-empty.policytest.hcl... running
      # resource.aws_waf_rule.pass_with_single_predicate... running
      # resource.aws_waf_rule.pass_with_single_predicate... pass
      # resource.aws_waf_rule.pass_with_multiple_predicates... running
      # resource.aws_waf_rule.pass_with_multiple_predicates... pass
      # resource.aws_waf_rule.fail_with_no_predicates_attribute... running
      # resource.aws_waf_rule.fail_with_no_predicates_attribute... pass
      # resource.aws_waf_rule.fail_with_empty_predicates_list... running
      # resource.aws_waf_rule.fail_with_empty_predicates_list... pass
      # waf-global-rule-not-empty.policytest.hcl... pass
```

---
