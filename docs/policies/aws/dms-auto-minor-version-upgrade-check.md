# DMS replication instances should have automatic minor version upgrade enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Vulnerability, patch, and version management |

## Description

This control checks if automatic minor version upgrade is enabled for an AWS DMS replication instance. The control fails if automatic minor version upgrade isn't enabled for a DMS replication instance.

DMS provides automatic minor version upgrade to each supported replication engine so that you can keep your replication instance up-to-date. Minor versions can introduce new software features, bug fixes, security patches, and performance improvements. By enabling automatic minor version upgrade on DMS replication instances, minor upgrades are applied automatically during the maintenance window or immediately if the Apply changes immediately option is chosen.

This rule is covered by the [dms-auto-minor-version-upgrade-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/dms/dms-auto-minor-version-upgrade-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # dms-auto-minor-version-upgrade-check.policytest.hcl...
      running
      # resource.aws_dms_replication_instance.pass_auto_upgrade_enabled...
      running
      # resource.aws_dms_replication_instance.pass_auto_upgrade_enabled...
      pass
      # resource.aws_dms_replication_instance.fail_auto_upgrade_disabled...
      running
      # resource.aws_dms_replication_instance.fail_auto_upgrade_disabled...
      pass
      # resource.aws_dms_replication_instance.fail_auto_upgrade_not_specified...
      running
      # resource.aws_dms_replication_instance.fail_auto_upgrade_not_specified...
      pass
      # resource.aws_dms_replication_instance.pass_auto_upgrade_with_full_config...
      running
      # resource.aws_dms_replication_instance.pass_auto_upgrade_with_full_config...
      pass
      # dms-auto-minor-version-upgrade-check.policytest.hcl...
      pass
```

---
