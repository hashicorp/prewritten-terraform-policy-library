# Amazon EC2 subnets should not automatically assign public IP addresses

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Network Security |

## Description

This control checks whether an Amazon Virtual Private Cloud (Amazon VPC) subnet is configured to automatically assign public IP addresses. The control fails if the subnet is configured to automatically assign public IPv4 or IPv6 addresses.

Subnets have attributes that determine whether network interfaces automatically receive public IPv4 and IPv6 addresses. For IPv4, this attribute is set to TRUE for default subnets and FALSE for nondefault subnets (with an exception for nondefault subnets created through the EC2 launch instance wizard, where it's set to TRUE). For IPv6, this attribute is set to FALSE for all subnets by default. When these attributes are enabled, instances launched in the subnet automatically receive the corresponding IP addresses (IPv4 or IPv6) on their primary network interface.

This rule is covered by the [subnet-auto-assign-public-ip-disabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/ec2/subnet-auto-assign-public-ip-disabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # subnet-auto-assign-public-ip-disabled.policytest.hcl...
      running
      # resource.aws_subnet.pass_both_false...
      running
      # resource.aws_subnet.pass_both_false...
      pass
      # resource.aws_subnet.pass_defaults...
      running
      # resource.aws_subnet.pass_defaults...
      pass
      # resource.aws_subnet.fail_ipv4_auto_assign...
      running
      # resource.aws_subnet.fail_ipv4_auto_assign...
      pass
      # resource.aws_subnet.fail_ipv6_auto_assign...
      running
      # resource.aws_subnet.fail_ipv6_auto_assign...
      pass
      # resource.aws_subnet.fail_both_true...
      running
      # resource.aws_subnet.fail_both_true...
      pass
      # subnet-auto-assign-public-ip-disabled.policytest.hcl...
      pass
```

---
