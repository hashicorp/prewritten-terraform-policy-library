# Network Firewall firewalls should have deletion protection enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Network Security |

## Description

This control checks whether an AWS Network Firewall firewall has deletion protection enabled. The control fails if deletion protection isn't enabled for a firewall.

AWS Network Firewall is a stateful, managed network firewall and intrusion detection service that enables you to inspect and filter traffic to, from, or between your Virtual Private Clouds (VPCs). The deletion protection setting protects against accidental deletion of the firewall.

This rule is covered by the [network-firewall-deletion-protection-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/network-firewall/network-firewall-deletion-protection-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # network-firewall-deletion-protection-enabled.policytest.hcl...
      running
      # resource.aws_networkfirewall_firewall.compliant...
      running
      # resource.aws_networkfirewall_firewall.compliant...
      pass
      # resource.aws_networkfirewall_firewall.non_compliant...
      running
      # resource.aws_networkfirewall_firewall.non_compliant...
      pass
      # resource.aws_networkfirewall_firewall.default...
      running
      # resource.aws_networkfirewall_firewall.default...
      pass
      # network-firewall-deletion-protection-enabled.policytest.hcl...
      pass
```

---
