# Stateless Network Firewall rule group should not be empty

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure Network Configuration |

## Description

This control checks if a stateless rule group in AWS Network Firewall contains rules. The control fails if there are no rules in the rule group.

A rule group contains rules that define how your firewall processes traffic in your VPC. An empty stateless rule group, when present in a firewall policy, might give the impression that the rule group will process traffic. However, when the stateless rule group is empty, it does not process traffic.

This rule is covered by the [network-firewall-stateless-rule-group-not-empty](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/network-firewall/network-firewall-stateless-rule-group-not-empty.policy.hcl) policy.

## Policy Results

```bash
trace:
      # network-firewall-stateless-rule-group-not-empty.policytest.hcl...
      running
      # resource.aws_networkfirewall_rule_group.pass_with_single_rule...
      running
      # resource.aws_networkfirewall_rule_group.pass_with_single_rule...
      pass
      # resource.aws_networkfirewall_rule_group.pass_with_multiple_rules...
      running
      # resource.aws_networkfirewall_rule_group.pass_with_multiple_rules...
      pass
      # resource.aws_networkfirewall_rule_group.fail_empty_rule_group...
      running
      # resource.aws_networkfirewall_rule_group.fail_empty_rule_group...
      pass
      # resource.aws_networkfirewall_rule_group.skip_stateful_rule_group...
      running
      # resource.aws_networkfirewall_rule_group.skip_stateful_rule_group...
      pass
      # network-firewall-stateless-rule-group-not-empty.policytest.hcl...
      pass
```

---
