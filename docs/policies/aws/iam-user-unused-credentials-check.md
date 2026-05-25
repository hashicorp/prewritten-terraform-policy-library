# Unused IAM user credentials should be removed

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

Parameters:

| Parameter | Value |
| --------- | ----- |
| maxCredentialUsageAge | 90 (not customizable) |

This control checks whether your IAM users have passwords or active access keys that have not been used for 90 days.

IAM users can access AWS resources using different types of credentials, such as passwords or access keys.

This rule is covered by the [iam-user-unused-credentials-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/iam/iam-user-unused-credentials-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # iam-user-unused-credentials-check.policytest.hcl...
      running
      # resource.aws_config_config_rule.config_rule_properly_configured...
      running
      # resource.aws_config_config_rule.config_rule_properly_configured...
      pass
      # resource.aws_config_config_rule.config_rule_wrong_source_identifier...
      running
      # resource.aws_config_config_rule.config_rule_wrong_source_identifier...
      pass
      # resource.aws_config_config_rule.config_rule_not_aws_managed...
      running
      # resource.aws_config_config_rule.config_rule_not_aws_managed...
      pass
      # resource.aws_config_config_rule.config_rule_fully_compliant...
      running
      # resource.aws_config_config_rule.config_rule_fully_compliant...
      pass
      # resource.aws_config_config_rule.config_rule_wrong_max_age...
      running
      # resource.aws_config_config_rule.config_rule_wrong_max_age...
      pass
      # resource.aws_config_config_rule.config_rule_multiple_violations...
      running
      # resource.aws_config_config_rule.config_rule_multiple_violations...
      pass
      # iam-user-unused-credentials-check.policytest.hcl...
      pass
```

---