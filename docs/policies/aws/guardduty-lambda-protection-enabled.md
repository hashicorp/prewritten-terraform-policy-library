# GuardDuty Lambda Protection should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether GuardDuty Lambda Protection is enabled. For a standalone account, the control fails if GuardDuty Lambda Protection is disabled in the account. In a multi-account environment, the control fails if the delegated GuardDuty administrator account and all member accounts don't have Lambda Protection enabled.

In a multi-account environment, the control generates findings in only the delegated GuardDuty administrator account. Only the delegated administrator can enable or disable the Lambda Protection feature for the member accounts in the organization. GuardDuty member accounts can't modify this configuration from their accounts. This control generates FAILED findings if the delegated GuardDuty administrator has a suspended member account that doesn't have GuardDuty Lambda Protection enabled. To receive a PASSED finding, the delegated administrator must disassociate these suspended accounts in GuardDuty.

GuardDuty Lambda Protection helps you identify potential security threats when an AWS Lambda function gets invoked. After your enable Lambda Protection, GuardDuty starts monitoring Lambda network activity logs associated with the Lambda functions in your AWS account. When a Lambda function gets invoked and GuardDuty identifies suspicious network traffic that indicates the presence of a potentially malicious piece of code in your Lambda function, GuardDuty generates a finding.

This rule is covered by the [guardduty-lambda-protection-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/guardduty/guardduty-lambda-protection-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # guardduty-lambda-protection-enabled.policytest.hcl... running
      # resource.aws_guardduty_detector_feature.pass_lambda_network_logs_enabled... running
      # resource.aws_guardduty_detector_feature.pass_lambda_network_logs_enabled... pass
      # resource.aws_guardduty_detector_feature.fail_lambda_network_logs_disabled... running
      # resource.aws_guardduty_detector_feature.fail_lambda_network_logs_disabled... pass
      # resource.aws_guardduty_detector_feature.fail_lambda_network_logs_status_missing... running
      # resource.aws_guardduty_detector_feature.fail_lambda_network_logs_status_missing... pass
      # resource.aws_guardduty_organization_configuration_feature.pass_org_lambda_network_logs... running
      # resource.aws_guardduty_organization_configuration_feature.pass_org_lambda_network_logs... pass
      # resource.aws_guardduty_organization_configuration_feature.fail_org_lambda_network_logs... running
      # resource.aws_guardduty_organization_configuration_feature.fail_org_lambda_network_logs... pass
      # resource.aws_guardduty_detector_feature.skip_different_feature... running
      # resource.aws_guardduty_detector_feature.skip_different_feature... pass
      # guardduty-lambda-protection-enabled.policytest.hcl... pass
```

---
