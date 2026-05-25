# The default stateless action for Network Firewall policies should be drop or forward for full packets

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure Network Configuration |

## Description

Paramters : statelessDefaultActions: aws:drop,aws:forward_to_sfe (not customizable)

This control checks whether the default stateless action for full packets for a Network Firewall policy is drop or forward. The control passes if Drop or Forward is selected, and fails if Pass is selected.

A firewall policy defines how your firewall monitors and handles traffic in Amazon VPC. You configure stateless and stateful rule groups to filter packets and traffic flows. Defaulting to Pass can allow unintended traffic.

This rule is covered by the [network-firewall-policy-default-action-full-packets](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/network-firewall/network-firewall-policy-default-action-full-packets.policy.hcl) policy.

## Policy Results

```bash
trace:
      # network-firewall-policy-default-action-full-packets.policytest.hcl...
      running
      # resource.aws_networkfirewall_firewall_policy.compliant_drop...
      running
      # resource.aws_networkfirewall_firewall_policy.compliant_drop...
      pass
      # resource.aws_networkfirewall_firewall_policy.compliant_forward...
      running
      # resource.aws_networkfirewall_firewall_policy.compliant_forward...
      pass
      # resource.aws_networkfirewall_firewall_policy.compliant_both...
      running
      # resource.aws_networkfirewall_firewall_policy.compliant_both...
      pass
      # resource.aws_networkfirewall_firewall_policy.compliant_with_custom...
      running
      # resource.aws_networkfirewall_firewall_policy.compliant_with_custom...
      pass
      # resource.aws_networkfirewall_firewall_policy.non_compliant_pass...
      running
      # resource.aws_networkfirewall_firewall_policy.non_compliant_pass...
      pass
      # resource.aws_networkfirewall_firewall_policy.non_compliant_mixed...
      running
      # resource.aws_networkfirewall_firewall_policy.non_compliant_mixed...
      pass
      # resource.aws_networkfirewall_firewall_policy.no_policy_block...
      running
      # resource.aws_networkfirewall_firewall_policy.no_policy_block...
      pass
      # network-firewall-policy-default-action-full-packets.policytest.hcl...
      pass
```

---
