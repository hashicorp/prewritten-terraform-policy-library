# Amazon Redshift clusters should prohibit public access

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources not publicly accessible |

## Description

This control checks whether Amazon Redshift clusters are publicly accessible. It evaluates the PubliclyAccessible field in the cluster configuration item.

The PubliclyAccessible attribute of the Amazon Redshift cluster configuration indicates whether the cluster is publicly accessible. When the cluster is configured with PubliclyAccessible set to true, it is an Internet-facing instance that has a publicly resolvable DNS name, which resolves to a public IP address.

When the cluster is not publicly accessible, it is an internal instance with a DNS name that resolves to a private IP address. Unless you intend for your cluster to be publicly accessible, the cluster should not be configured with PubliclyAccessible set to true.

This rule is covered by the [redshift-cluster-public-access-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/redshift/redshift-cluster-public-access-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # redshift-cluster-public-access-check.policytest.hcl... running
      # resource.aws_redshift_cluster.pass_explicit_false... running
      # resource.aws_redshift_cluster.pass_explicit_false... pass
      # resource.aws_redshift_cluster.pass_default_false... running
      # resource.aws_redshift_cluster.pass_default_false... pass
      # resource.aws_redshift_cluster.fail_public_access_enabled... running
      # resource.aws_redshift_cluster.fail_public_access_enabled... pass
      # redshift-cluster-public-access-check.policytest.hcl... pass
```

---
