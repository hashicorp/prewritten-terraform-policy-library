# Elastic Beanstalk managed platform updates should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Vulnerability, patch, and version management |

## Description

This control checks whether managed platform updates are enabled for an Elastic Beanstalk environment. The control fails if no managed platform updates are enabled. By default, the control passes if any type of platform update is enabled. Optionally, you can provide a custom parameter value to require a specific update level.

Enabling managed platform updates ensures that the latest available platform fixes, updates, and features for the environment are installed. Keeping up to date with patch installation is an important step in securing systems.

This rule is covered by the [elastic-beanstalk-managed-updates-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/elasticbeanstalk/elastic-beanstalk-managed-updates-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elastic-beanstalk-managed-updates-enabled.policytest.hcl...
      running
      # resource.aws_elastic_beanstalk_environment.pass_managed_updates_enabled...
      running
      # resource.aws_elastic_beanstalk_environment.pass_managed_updates_enabled...
      pass
      # resource.aws_elastic_beanstalk_environment.pass_managed_updates_with_level...
      running
      # resource.aws_elastic_beanstalk_environment.pass_managed_updates_with_level...
      pass
      # resource.aws_elastic_beanstalk_environment.fail_no_managed_updates...
      running
      # resource.aws_elastic_beanstalk_environment.fail_no_managed_updates...
      pass
      # resource.aws_elastic_beanstalk_environment.fail_managed_updates_disabled...
      running
      # resource.aws_elastic_beanstalk_environment.fail_managed_updates_disabled...
      pass
      # resource.aws_elastic_beanstalk_environment.fail_empty_settings...
      running
      # resource.aws_elastic_beanstalk_environment.fail_empty_settings...
      pass
      # resource.aws_elastic_beanstalk_environment.fail_update_level_mismatch...
      running
      # resource.aws_elastic_beanstalk_environment.fail_update_level_mismatch...
      pass
      # elastic-beanstalk-managed-updates-enabled.policytest.hcl...
      pass
```

---
