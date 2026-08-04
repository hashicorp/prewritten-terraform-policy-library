# GuardDuty EKS Runtime Monitoring should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection Services |

## Description

This control checks whether GuardDuty EKS Runtime Monitoring with automated agent management is enabled. For a standalone account, the control fails if GuardDuty EKS Runtime Monitoring with automated agent management is disabled in the account. In a multi-account environment, the control fails if the delegated GuardDuty administrator account and all member accounts don't have EKS Runtime Monitoring with automated agent management enabled.

In a multi-account environment, the control generates findings in only the delegated GuardDuty administrator account. Only the delegated administrator can enable or disable the EKS Runtime Monitoring feature with automated agent management for the member accounts in the organization. GuardDuty member accounts can't modify this configuration from their accounts. This control generates FAILED findings if the delegated GuardDuty administrator has a suspended member account that doesn't have GuardDuty EKS Runtime Monitoring enabled. To receive a PASSED finding, the delegated administrator must disassociate these suspended accounts in GuardDuty.

EKS Protection in Amazon GuardDuty provides threat detection coverage to help you protect Amazon EKS clusters within your AWS environment. EKS Runtime Monitoring uses operating system-level events to help you detect potential threats in EKS nodes and containers within your EKS clusters.

This rule is covered by the [guardduty-eks-protection-runtime-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/guardduty/guardduty-eks-protection-runtime-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # guardduty-eks-protection-runtime-enabled.policytest.hcl... running
      # resource.aws_guardduty_detector_feature.pass_fully_enabled... running
      # resource.aws_guardduty_detector_feature.pass_fully_enabled... pass
      # resource.aws_guardduty_detector_feature.fail_feature_disabled... running
      # resource.aws_guardduty_detector_feature.fail_feature_disabled... pass
      # resource.aws_guardduty_detector_feature.fail_addon_management_disabled... running
      # resource.aws_guardduty_detector_feature.fail_addon_management_disabled... pass
      # resource.aws_guardduty_detector_feature.fail_no_addon_management... running
      # resource.aws_guardduty_detector_feature.fail_no_addon_management... pass
      # resource.aws_guardduty_organization_configuration_feature.pass_org_fully_enabled... running
      # resource.aws_guardduty_organization_configuration_feature.pass_org_fully_enabled... pass
      # resource.aws_guardduty_organization_configuration_feature.fail_org_feature_disabled... running
      # resource.aws_guardduty_organization_configuration_feature.fail_org_feature_disabled... pass
      # resource.aws_guardduty_organization_configuration_feature.fail_org_addon_management_disabled... running
      # resource.aws_guardduty_organization_configuration_feature.fail_org_addon_management_disabled... pass
      # resource.aws_guardduty_organization_configuration_feature.fail_org_no_addon_management... running
      # resource.aws_guardduty_organization_configuration_feature.fail_org_no_addon_management... pass
      # resource.aws_guardduty_detector_feature.pass_different_feature_filtered... running
      # resource.aws_guardduty_detector_feature.pass_different_feature_filtered... pass
      # guardduty-eks-protection-runtime-enabled.policytest.hcl... pass
```

---
