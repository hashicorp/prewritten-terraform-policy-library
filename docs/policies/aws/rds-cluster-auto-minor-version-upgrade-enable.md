# RDS DB clusters should have automatic minor version upgrade enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Vulnerability, patch, and version management |

## Description

This control checks if automatic minor version upgrade is enabled for an Amazon RDS Multi-AZ DB cluster. The control fails if automatic minor version upgrade isn't enabled for the Multi-AZ DB cluster.

RDS provides automatic minor version upgrade so that you can keep your Multi-AZ DB cluster up to date. Minor versions can introduce new software features, bug fixes, security patches, and performance improvements. By enabling automatic minor version upgrade on RDS database clusters, the cluster, along with the instances in the cluster, will receive automatic updates to the minor version when new versions are available. The updates are applied automatically during the maintenance window.

This rule is covered by the [rds-cluster-auto-minor-version-upgrade-enable](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-cluster-auto-minor-version-upgrade-enable.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-cluster-auto-minor-version-upgrade-enable.policytest.hcl... running
      # resource.aws_rds_cluster_instance.pass_explicit_true... running
      # resource.aws_rds_cluster_instance.pass_explicit_true... pass
      # resource.aws_rds_cluster_instance.pass_default_true... running
      # resource.aws_rds_cluster_instance.pass_default_true... pass
      # resource.aws_rds_cluster_instance.fail_explicit_false... running
      # resource.aws_rds_cluster_instance.fail_explicit_false... pass
      # rds-cluster-auto-minor-version-upgrade-enable.policytest.hcl... pass
```

---
