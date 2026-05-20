# GuardDuty S3 Protection should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether GuardDuty S3 Protection is enabled. For a standalone account, the control fails if GuardDuty S3 Protection is disabled in the account. In a multi-account environment, the control fails if the delegated GuardDuty administrator account and all member accounts don't have S3 Protection enabled.

In a multi-account environment, the control generates findings in only the delegated GuardDuty administrator account. Only the delegated administrator can enable or disable the S3 Protection feature for the member accounts in the organization. GuardDuty member accounts can't modify this configuration from their accounts. This control generates FAILED findings if the delegated GuardDuty administrator has a suspended member account that doesn't have GuardDuty S3 Protection enabled. To receive a PASSED finding, the delegated administrator must disassociate these suspended accounts in GuardDuty.

S3 Protection enables GuardDuty to monitor object-level API operations to identify potential security risks for data within your Amazon Simple Storage Service (Amazon S3) buckets. GuardDuty monitors threats against your S3 resources by analyzing AWS CloudTrail management events and CloudTrail S3 data events.

This rule is covered by the [guardduty-s3-protection-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/guardduty/guardduty-s3-protection-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # guardduty-s3-protection-enabled.policytest.hcl... running
      # resource.aws_guardduty_detector_feature.pass_feature_enabled... running
      # resource.aws_guardduty_detector_feature.pass_feature_enabled... pass
      # resource.aws_guardduty_detector_feature.fail_feature_disabled... running
      # resource.aws_guardduty_detector_feature.fail_feature_disabled... pass
      # resource.aws_guardduty_detector_feature.skip_different_feature... running
      # resource.aws_guardduty_detector_feature.skip_different_feature... pass
      # resource.aws_guardduty_organization_configuration_feature.pass_org_s3_logs... running
      # resource.aws_guardduty_organization_configuration_feature.pass_org_s3_logs... pass
      # resource.aws_guardduty_organization_configuration_feature.fail_org_s3_logs... running
      # resource.aws_guardduty_organization_configuration_feature.fail_org_s3_logs... pass
      # guardduty-s3-protection-enabled.policytest.hcl... pass
```

---
