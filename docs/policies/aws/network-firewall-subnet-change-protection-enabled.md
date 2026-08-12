# Network Firewall firewalls should have subnet change protection enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Network Security |

## Description

This control checks whether subnet change protection is enabled for an AWS Network Firewall firewall. The control fails if subnet change protection isn't enabled for the firewall.

AWS Network Firewall is a stateful, managed network firewall and intrusion detection service that you can use to inspect and filter traffic to, from, or between your Virtual Private Clouds (VPCs). If you enable subnet change protection for a Network Firewall firewall, you can protect the firewall against accidental changes to the firewall's subnet associations.

This rule is covered by the [network-firewall-subnet-change-protection-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/network-firewall/network-firewall-subnet-change-protection-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # network-firewall-subnet-change-protection-enabled.policytest.hcl...
      running
      # resource.aws_networkfirewall_firewall.pass_protection_enabled...
      running
      # resource.aws_networkfirewall_firewall.pass_protection_enabled...
      pass
      # resource.aws_networkfirewall_firewall.fail_protection_disabled...
      running
      # resource.aws_networkfirewall_firewall.fail_protection_disabled...
      pass
      # resource.aws_networkfirewall_firewall.fail_protection_not_specified...
      running
      # resource.aws_networkfirewall_firewall.fail_protection_not_specified...
      pass
      # network-firewall-subnet-change-protection-enabled.policytest.hcl...
      pass
```

---