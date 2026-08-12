# RDS automatic minor version upgrades should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Vulnerability, patch, and version management |

## Description

This control checks whether automatic minor version upgrades are enabled for the RDS database instance.

Automatic minor version upgrades periodically update a database to recent database engine versions. However, the upgrade might not always include the latest database engine version. If you need to keep your databases on specific versions at particular times, we recommend that you manually upgrade to the database versions that you need according to your required schedule. In cases of critical security issues or when a version reaches its end-of-support date, Amazon RDS might apply a minor version upgrade even if you haven't enabled the Auto minor version upgrade option. For more information, see the Amazon RDS upgrade documentation for your specific database engine:

This rule is covered by the [rds-automatic-minor-version-upgrade-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/rds/rds-automatic-minor-version-upgrade-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-automatic-minor-version-upgrade-enabled.policytest.hcl... running
      # resource.aws_db_instance.pass_version_upgrade_enabled... running
      # resource.aws_db_instance.pass_version_upgrade_enabled... pass
      # resource.aws_db_instance.fail_version_upgrade_disabled... running
      # resource.aws_db_instance.fail_version_upgrade_disabled... pass
      # resource.aws_db_instance.pass_version_upgrade_missing... running
      # resource.aws_db_instance.pass_version_upgrade_missing... pass
      # rds-automatic-minor-version-upgrade-enabled.policytest.hcl... pass
```

---
