# SSM documents should have the block public sharing setting enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resource not publicly accessible |

## Description

This control checks whether the block public sharing setting is enabled for AWS Systems Manager documents. The control fails if the block public sharing setting is disabled for Systems Manager documents.

The block public sharing setting for AWS Systems Manager (SSM) documents is an account-level setting. Enabling this setting can prevent unwanted access to your SSM documents. If you enable this setting, your change doesn't affect any SSM documents that you're currently sharing with the public. Unless your use case requires you to share SSM documents with the public, we recommend that you enable the block public sharing setting. The setting can differ for each AWS Region.

This rule is covered by the [ssm-automation-block-public-sharing](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ssm/ssm-automation-block-public-sharing.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ssm-automation-block-public-sharing.policytest.hcl... running
      # resource.aws_ssm_service_setting.pass_setting_disabled... running
      # resource.aws_ssm_service_setting.pass_setting_disabled... pass
      # resource.aws_ssm_service_setting.fail_setting_enabled... running
      # resource.aws_ssm_service_setting.fail_setting_enabled... pass
      # resource.aws_ssm_document.skip_no_permissions... running
      # resource.aws_ssm_document.skip_no_permissions... pass
      # resource.aws_ssm_document.fail_public_document... running
      # resource.aws_ssm_document.fail_public_document... pass
      # resource.aws_ssm_document.pass_specific_accounts... running
      # resource.aws_ssm_document.pass_specific_accounts... pass
      # resource.aws_ssm_document.pass_non_share_type... running
      # resource.aws_ssm_document.pass_non_share_type... pass
      # ssm-automation-block-public-sharing.policytest.hcl... pass
```

---
