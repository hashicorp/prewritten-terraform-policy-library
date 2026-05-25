# Redshift clusters should use enhanced VPC routing

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | API private access |

## Description

This control checks whether an Amazon Redshift cluster has EnhancedVpcRouting enabled.

Enhanced VPC routing forces all COPY and UNLOAD traffic between the cluster and data repositories to go through your VPC. You can then use VPC features such as security groups and network access control lists to secure network traffic. You can also use VPC Flow Logs to monitor network traffic.

This rule is covered by the [redshift-enhanced-vpc-routing-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/redshift/redshift-enhanced-vpc-routing-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # redshift-enhanced-vpc-routing-enabled.policytest.hcl... running
      # resource.aws_redshift_cluster.pass_explicit_true... running
      # resource.aws_redshift_cluster.pass_explicit_true... pass
      # resource.aws_redshift_cluster.fail_explicit_false... running
      # resource.aws_redshift_cluster.fail_explicit_false... pass
      # resource.aws_redshift_cluster.fail_default_false... running
      # resource.aws_redshift_cluster.fail_default_false... pass
      # redshift-enhanced-vpc-routing-enabled.policytest.hcl... pass
```

---
