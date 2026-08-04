# AWS WAF Classic Regional rule groups should have at least one rule

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure network configuration |

## Description

This control checks whether an AWS WAF Regional rule group has at least one rule. The control fails if no rules are present within a rule group.

A WAF Regional rule group can contain multiple rules. The rule's conditions allow for traffic inspection and take a defined action (allow, block, or count). Without any rules, the traffic passes without inspection. A WAF Regional rule group with no rules, but with a name or tag suggesting allow, block, or count, could lead to the wrong assumption that one of those actions is occurring.

This rule is covered by the [waf-regional-rulegroup-not-empty](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/waf/waf-regional-rulegroup-not-empty.policy.hcl) policy.

## Policy Results

```bash
trace:
      # waf-regional-rulegroup-not-empty.policytest.hcl... running
      # resource.aws_wafregional_rule_group.pass_with_one_activated_rule... running
      # resource.aws_wafregional_rule_group.pass_with_one_activated_rule... pass
      # resource.aws_wafregional_rule_group.pass_with_multiple_activated_rules... running
      # resource.aws_wafregional_rule_group.pass_with_multiple_activated_rules... pass
      # resource.aws_wafregional_rule_group.fail_with_no_activated_rule_blocks... running
      # resource.aws_wafregional_rule_group.fail_with_no_activated_rule_blocks... pass
      # resource.aws_wafregional_rule_group.fail_with_empty_activated_rule_list... running
      # resource.aws_wafregional_rule_group.fail_with_empty_activated_rule_list... pass
      # waf-regional-rulegroup-not-empty.policytest.hcl... pass
```

---
