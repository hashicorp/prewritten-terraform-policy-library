# Network Firewall firewalls should be deployed across multiple Availability Zones

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | High availability |

## Description

This control evaluates whether a firewall managed through AWS Network Firewall is deployed across multiple Availability Zones (AZs). The control fails if a firewall is deployed in only one AZ.

AWS global infrastructure includes multiple AWS Regions. AZs are physically separated, isolated locations within each Region that are connected by low-latency, high-throughput, and highly redundant networking. By deploying a Network Firewall firewall across multiple AZs, you can balance and shift traffic among AZs, which helps you design highly available solutions.

This rule is covered by the [network-firewall-should-be-deployed-across-multiple-azs](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/network-firewall/network-firewall-should-be-deployed-across-multiple-azs.policy.hcl) policy.

## Policy Results

```bash
trace:
      # network-firewall-should-be-deployed-across-multiple-azs.policytest.hcl... running
      # resource.aws_networkfirewall_firewall.two_azs... running
      # resource.aws_networkfirewall_firewall.two_azs... pass
      # resource.aws_networkfirewall_firewall.three_azs... running
      # resource.aws_networkfirewall_firewall.three_azs... pass
      # resource.aws_networkfirewall_firewall.one_az... running
      # resource.aws_networkfirewall_firewall.one_az... pass
      # resource.aws_networkfirewall_firewall.empty_mapping... running
      # resource.aws_networkfirewall_firewall.empty_mapping... pass
      # resource.aws_networkfirewall_firewall.null_mapping... running
      # resource.aws_networkfirewall_firewall.null_mapping... pass
      # resource.aws_networkfirewall_firewall.absent_mapping... running
      # resource.aws_networkfirewall_firewall.absent_mapping... pass
      # network-firewall-should-be-deployed-across-multiple-azs.policytest.hcl... pass
```

---