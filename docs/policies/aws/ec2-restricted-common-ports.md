# Security groups should not allow unrestricted access to ports with high risk

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Restricted network access |

## Description

This control checks whether unrestricted incoming traffic for an Amazon EC2 security group is accessible to the specified ports that are considered to be high risk. This control fails if any of the rules in a security group allow ingress traffic from '0.0.0.0/0' or '::/0' to those ports.

Security groups provide stateful filtering of ingress and egress network traffic to AWS resources. Unrestricted access (0.0.0.0/0) increases opportunities for malicious activity, such as hacking, denial-of-service attacks, and loss of data. No security group should allow unrestricted ingress access to the following ports:

3000 (Go, Node.js, and Ruby web development frameworks)

This rule is covered by the [ec2-restricted-common-ports](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/ec2/ec2-restricted-common-ports.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ec2-restricted-common-ports.policytest.hcl... running
      # resource.aws_vpc_security_group_ingress_rule.ssh_unrestricted... running
      # resource.aws_vpc_security_group_ingress_rule.ssh_unrestricted... pass
      # resource.aws_vpc_security_group_ingress_rule.rdp_unrestricted... running
      # resource.aws_vpc_security_group_ingress_rule.rdp_unrestricted... pass
      # resource.aws_vpc_security_group_ingress_rule.mysql_unrestricted... running
      # resource.aws_vpc_security_group_ingress_rule.mysql_unrestricted... pass
      # resource.aws_vpc_security_group_ingress_rule.postgresql_unrestricted_ipv6... running
      # resource.aws_vpc_security_group_ingress_rule.postgresql_unrestricted_ipv6... pass
      # resource.aws_vpc_security_group_ingress_rule.ftp_unrestricted... running
      # resource.aws_vpc_security_group_ingress_rule.ftp_unrestricted... pass
      # resource.aws_vpc_security_group_ingress_rule.mssql_unrestricted_ipv6... running
      # resource.aws_vpc_security_group_ingress_rule.mssql_unrestricted_ipv6... pass
      # resource.aws_vpc_security_group_ingress_rule.opensearch_unrestricted... running
      # resource.aws_vpc_security_group_ingress_rule.opensearch_unrestricted... pass
      # resource.aws_vpc_security_group_ingress_rule.all_protocols_unrestricted... running
      # resource.aws_vpc_security_group_ingress_rule.all_protocols_unrestricted... pass
      # resource.aws_vpc_security_group_ingress_rule.multiple_high_risk_ports... running
      # resource.aws_vpc_security_group_ingress_rule.multiple_high_risk_ports... pass
      # resource.aws_vpc_security_group_ingress_rule.http_unrestricted... running
      # resource.aws_vpc_security_group_ingress_rule.http_unrestricted... pass
      # resource.aws_vpc_security_group_ingress_rule.https_unrestricted... running
      # resource.aws_vpc_security_group_ingress_rule.https_unrestricted... pass
      # resource.aws_vpc_security_group_ingress_rule.ssh_restricted... running
      # resource.aws_vpc_security_group_ingress_rule.ssh_restricted... pass
      # resource.aws_vpc_security_group_ingress_rule.rdp_restricted_ipv6... running
      # resource.aws_vpc_security_group_ingress_rule.rdp_restricted_ipv6... pass
      # resource.aws_vpc_security_group_ingress_rule.high_risk_range_restricted... running
      # resource.aws_vpc_security_group_ingress_rule.high_risk_range_restricted... pass
      # resource.aws_vpc_security_group_ingress_rule.all_protocols_restricted... running
      # resource.aws_vpc_security_group_ingress_rule.all_protocols_restricted... pass
      # ec2-restricted-common-ports.policytest.hcl... pass
```

---
