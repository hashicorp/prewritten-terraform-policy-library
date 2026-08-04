# GuardDuty EKS Audit Log Monitoring should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether GuardDuty EKS Audit Log Monitoring is enabled. For a standalone account, the control fails if GuardDuty EKS Audit Log Monitoring is disabled in the account. In a multi-account environment, the control fails if the delegated GuardDuty administrator account and all member accounts don't have EKS Audit Log Monitoring enabled.

In a multi-account environment, the control generates findings in only the delegated GuardDuty administrator account. Only the delegated administrator can enable or disable the EKS Audit Log Monitoring feature for the member accounts in the organization. GuardDuty member accounts can't modify this configuration from their accounts. This control generates FAILED findings if the delegated GuardDuty administrator has a suspended member account that doesn't have GuardDuty EKS Audit Log Monitoring enabled. To receive a PASSED finding, the delegated administrator must disassociate these suspended accounts in GuardDuty.

GuardDuty EKS Audit Log Monitoring helps you detect potentially suspicious activities in your Amazon Elastic Kubernetes Service (Amazon EKS) clusters. EKS Audit Log Monitoring uses Kubernetes audit logs to capture chronological activities from users, applications using the Kubernetes API, and the control plane.

This rule is covered by the [guardduty-eks-protection-audit-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/guardduty/guardduty-eks-protection-audit-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # guardduty-eks-protection-audit-enabled.policytest.hcl... running
      # resource.aws_guardduty_detector_feature.pass_standalone_enabled... running
      # resource.aws_guardduty_detector_feature.pass_standalone_enabled... pass
      # resource.aws_guardduty_detector_feature.fail_standalone_disabled... running
      # resource.aws_guardduty_detector_feature.fail_standalone_disabled... pass
      # resource.aws_guardduty_detector_feature.fail_standalone_missing_status... running
      # resource.aws_guardduty_detector_feature.fail_standalone_missing_status... pass
      # resource.aws_guardduty_organization_configuration_feature.pass_org_auto_enable_all... running
      # resource.aws_guardduty_organization_configuration_feature.pass_org_auto_enable_all... pass
      # resource.aws_guardduty_organization_configuration_feature.fail_org_auto_enable_none... running
      # resource.aws_guardduty_organization_configuration_feature.fail_org_auto_enable_none... pass
      # resource.aws_guardduty_detector_feature.skip_different_feature_standalone... running
      # resource.aws_guardduty_detector_feature.skip_different_feature_standalone... pass
      # guardduty-eks-protection-audit-enabled.policytest.hcl... pass
```

---
