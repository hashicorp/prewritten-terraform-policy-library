# Amazon Redshift should have automatic upgrades to major versions enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Vulnerability, patch, and version management |

## Description

This control checks whether automatic major version upgrades are enabled for the Amazon Redshift cluster.

Enabling automatic major version upgrades ensures that the latest major version updates to Amazon Redshift clusters are installed during the maintenance window. These updates might include security patches and bug fixes. Keeping up to date with patch installation is an important step in securing systems.

This rule is covered by the [redshift-cluster-maintenancesettings-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/redshift/redshift-cluster-maintenancesettings-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # redshift-cluster-maintenancesettings-check.policytest.hcl... running
      # resource.aws_redshift_cluster.pass_explicit_true... running
      # resource.aws_redshift_cluster.pass_explicit_true... pass
      # resource.aws_redshift_cluster.fail_explicit_false... running
      # resource.aws_redshift_cluster.fail_explicit_false... pass
      # resource.aws_redshift_cluster.pass_default_value... running
      # resource.aws_redshift_cluster.pass_default_value... pass
      # resource.aws_redshift_cluster.pass_snapshot_retention_positive... running
      # resource.aws_redshift_cluster.pass_snapshot_retention_positive... pass
      # resource.aws_redshift_cluster.fail_snapshot_retention_zero... running
      # resource.aws_redshift_cluster.fail_snapshot_retention_zero... pass
      # resource.aws_redshift_cluster.pass_snapshot_retention_default... running
      # resource.aws_redshift_cluster.pass_snapshot_retention_default... pass
      # resource.aws_redshift_cluster.fail_both_conditions... running
      # resource.aws_redshift_cluster.fail_both_conditions... pass
      # resource.aws_redshift_cluster.pass_with_maintenance_window... running
      # resource.aws_redshift_cluster.pass_with_maintenance_window... pass
      # redshift-cluster-maintenancesettings-check.policytest.hcl... pass
```

---
