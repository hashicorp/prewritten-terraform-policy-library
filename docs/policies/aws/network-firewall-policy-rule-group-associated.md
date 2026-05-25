# Network Firewall policies should have at least one rule group associated

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure Network Configuration |

## Description

This control checks whether a Network Firewall policy has any stateful or stateless rule groups associated. The control fails if stateless or stateful rule groups are not assigned.

A firewall policy defines how your firewall monitors and handles traffic in Amazon Virtual Private Cloud (Amazon VPC). Configuration of stateless and stateful rule groups helps to filter packets and traffic flows, and defines default traffic handling.

This rule is covered by the [network-firewall-policy-rule-group-associated](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/network-firewall/network-firewall-policy-rule-group-associated.policy.hcl) policy.

## Policy Results

```bash
trace:
      # network-firewall-policy-rule-group-associated.policytest.hcl...
      running
      # resource.aws_networkfirewall_firewall_policy.pass_with_stateful_rule_groups...
      running
      # resource.aws_networkfirewall_firewall_policy.pass_with_stateful_rule_groups...
      pass
      # resource.aws_networkfirewall_firewall_policy.pass_with_stateless_rule_groups...
      running
      # resource.aws_networkfirewall_firewall_policy.pass_with_stateless_rule_groups...
      pass
      # resource.aws_networkfirewall_firewall_policy.pass_with_both_rule_groups...
      running
      # resource.aws_networkfirewall_firewall_policy.pass_with_both_rule_groups...
      pass
      # resource.aws_networkfirewall_firewall_policy.fail_without_rule_groups...
      running
      # resource.aws_networkfirewall_firewall_policy.fail_without_rule_groups...
      pass
      # resource.aws_networkfirewall_firewall_policy.fail_with_empty_rule_groups...
      running
      # resource.aws_networkfirewall_firewall_policy.fail_with_empty_rule_groups...
      pass
      # resource.aws_networkfirewall_firewall_policy.pass_with_multiple_stateful_rule_groups...
      running
      # resource.aws_networkfirewall_firewall_policy.pass_with_multiple_stateful_rule_groups...
      pass
      # network-firewall-policy-rule-group-associated.policytest.hcl...
      pass
```

---
