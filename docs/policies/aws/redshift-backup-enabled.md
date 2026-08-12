# Amazon Redshift clusters should have automatic snapshots enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Backups enabled |

## Description

This control checks whether an Amazon Redshift cluster has automated snapshots enabled, and a retention period greater than or equal to the specified time frame. The control fails if automated snapshots aren't enabled for the cluster, or if the retention period is less than the specified time frame. Unless you provide a custom parameter value for the snapshot retention period, Security Hub CSPM uses a default value of 7 days.

Backups help you to recover more quickly from a security incident. They strengthen the resilience of your systems. Amazon Redshift takes periodic snapshots by default. This control checks whether automatic snapshots are enabled and retained for at least seven days. For more details on Amazon Redshift automated snapshots, see Automated snapshots in the Amazon Redshift Management Guide.

This rule is covered by the [redshift-backup-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/redshift/redshift-backup-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # redshift-backup-enabled.policytest.hcl... running
      # resource.aws_redshift_cluster.pass_1day... running
      # resource.aws_redshift_cluster.pass_1day... pass
      # resource.aws_redshift_cluster.pass_7days... running
      # resource.aws_redshift_cluster.pass_7days... pass
      # resource.aws_redshift_cluster.pass_35days... running
      # resource.aws_redshift_cluster.pass_35days... pass
      # resource.aws_redshift_cluster.fail_disabled... running
      # resource.aws_redshift_cluster.fail_disabled... pass
      # resource.aws_redshift_cluster.fail_36days... running
      # resource.aws_redshift_cluster.fail_36days... pass
      # resource.aws_redshift_cluster.fail_50days... running
      # resource.aws_redshift_cluster.fail_50days... pass
      # redshift-backup-enabled.policytest.hcl... pass
```

---
