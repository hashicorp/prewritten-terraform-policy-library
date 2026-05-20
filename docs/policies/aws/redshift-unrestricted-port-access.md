# Redshift security groups should allow ingress on the cluster port only from restricted origins

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Security group configuration |

## Description

This control checks whether a security group associated with an Amazon Redshift cluster has ingress rules that permit access to the cluster port from the internet (0.0.0.0/0 or ::/0). The control fails if the security group ingress rules permit access to the cluster port from the internet.

Permitting unrestricted inbound access to the Redshift cluster port (IP address with a /0 suffix) can result in unauthorized access or security incidents. We recommend applying the principal of least privilege access when creating security groups and configuring inbound rules.

This rule is covered by the [redshift-unrestricted-port-access](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/redshift/redshift-unrestricted-port-access.policy.hcl) policy.

## Policy Results

```bash
trace:
      # redshift-unrestricted-port-access.policytest.hcl... running
      # resource.aws_redshift_cluster.pass_no_security_groups... running
      # resource.aws_redshift_cluster.pass_no_security_groups... pass
      # resource.aws_redshift_cluster.pass_restricted_access... running
      # resource.aws_redshift_cluster.pass_restricted_access... pass
      # resource.aws_redshift_cluster.pass_restricted_ipv6... running
      # resource.aws_redshift_cluster.pass_restricted_ipv6... pass
      # resource.aws_redshift_cluster.pass_different_port... running
      # resource.aws_redshift_cluster.pass_different_port... pass
      # resource.aws_redshift_cluster.pass_custom_port_restricted... running
      # resource.aws_redshift_cluster.pass_custom_port_restricted... pass
      # resource.aws_redshift_cluster.fail_unrestricted_ipv4... running
      # resource.aws_redshift_cluster.fail_unrestricted_ipv4... pass
      # resource.aws_redshift_cluster.fail_unrestricted_ipv6... running
      # resource.aws_redshift_cluster.fail_unrestricted_ipv6... pass
      # resource.aws_redshift_cluster.fail_port_range_unrestricted... running
      # resource.aws_redshift_cluster.fail_port_range_unrestricted... pass
      # resource.aws_redshift_cluster.fail_all_protocols_unrestricted... running
      # resource.aws_redshift_cluster.fail_all_protocols_unrestricted... pass
      # resource.aws_redshift_cluster.fail_custom_port_unrestricted... running
      # resource.aws_redshift_cluster.fail_custom_port_unrestricted... pass
      # resource.aws_redshift_cluster.fail_multiple_sgs_one_unrestricted... running
      # resource.aws_redshift_cluster.fail_multiple_sgs_one_unrestricted... pass
      # resource.aws_redshift_cluster.pass_multiple_sgs_all_restricted... running
      # resource.aws_redshift_cluster.pass_multiple_sgs_all_restricted... pass
      # resource.aws_redshift_cluster.fail_sg_multiple_rules_one_unrestricted... running
      # resource.aws_redshift_cluster.fail_sg_multiple_rules_one_unrestricted... pass
      # resource.aws_redshift_cluster.pass_default_port_restricted... running
      # resource.aws_redshift_cluster.pass_default_port_restricted... pass
      # resource.aws_redshift_cluster.fail_wide_port_range_unrestricted... running
      # resource.aws_redshift_cluster.fail_wide_port_range_unrestricted... pass
      # resource.aws_redshift_cluster.pass_multiple_sgs_partial_rules_defined... running
      # resource.aws_redshift_cluster.pass_multiple_sgs_partial_rules_defined... pass
      # redshift-unrestricted-port-access.policytest.hcl... pass
```

---
