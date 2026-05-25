# The default stateless action for Network Firewall policies should be drop or forward for fragmented packets

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure Network Configuration |

## Description

Parameters : statelessFragDefaultActions (Required) : aws:drop, aws:forward_to_sfe (not customizable)

This control checks whether the default stateless action for fragmented packets for a Network Firewall policy is drop or forward. The control passes if Drop or Forward is selected, and fails if Pass is selected.

A firewall policy defines how your firewall monitors and handles traffic in Amazon VPC. You configure stateless and stateful rule groups to filter packets and traffic flows. Defaulting to Pass can allow unintended traffic.

This rule is covered by the [network-firewall-policy-default-action-fragment-packets](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/network-firewall/network-firewall-policy-default-action-fragment-packets.policy.hcl) policy.

## Policy Results

```bash
trace:
      # network-firewall-policy-default-action-fragment-packets.policytest.hcl...
      running
      # resource.aws_networkfirewall_firewall_policy.pass_with_drop_action...
      running
      # resource.aws_networkfirewall_firewall_policy.pass_with_drop_action...
      pass
      # resource.aws_networkfirewall_firewall_policy.pass_with_forward_action...
      running
      # resource.aws_networkfirewall_firewall_policy.pass_with_forward_action...
      pass
      # resource.aws_networkfirewall_firewall_policy.fail_with_pass_action...
      running
      # resource.aws_networkfirewall_firewall_policy.fail_with_pass_action...
      pass
      # resource.aws_networkfirewall_firewall_policy.fail_with_empty_actions...
      running
      # resource.aws_networkfirewall_firewall_policy.fail_with_empty_actions...
      pass
      # resource.aws_networkfirewall_firewall_policy.pass_with_drop_and_custom_action...
      running
      # resource.aws_networkfirewall_firewall_policy.pass_with_drop_and_custom_action...
      pass
      # resource.aws_networkfirewall_firewall_policy.fail_with_pass_and_drop_mixed...
      running
      # resource.aws_networkfirewall_firewall_policy.fail_with_pass_and_drop_mixed...
      pass
      # network-firewall-policy-default-action-fragment-packets.policytest.hcl...
      pass
```

---
