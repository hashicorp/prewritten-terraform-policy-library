# Amazon Inspector Lambda code scanning should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether Amazon Inspector Lambda code scanning is enabled. For a standalone account, the control fails if Amazon Inspector Lambda code scanning is disabled in the account. In a multi-account environment, the control fails if the delegated Amazon Inspector administrator account and all member accounts don't have Lambda code scanning enabled.

In a multi-account environment, the control generates findings in only the delegated Amazon Inspector administrator account. Only the delegated administrator can enable or disable the Lambda code scanning feature for the member accounts in the organization. Amazon Inspector member accounts can't modify this configuration from their accounts. This control generates FAILED findings if the delegated administrator has a suspended member account that doesn't have Amazon Inspector Lambda code scanning enabled. To receive a PASSED finding, the delegated administrator must disassociate these suspended accounts in Amazon Inspector.

Amazon Inspector Lambda code scanning scans the custom application code within an AWS Lambda function for code vulnerabilities based on AWS security best practices. Lambda code scanning can detect injection flaws, data leaks, weak cryptography, or missing encryption in your code. This feature is available in specific AWS Regions only. You can activate Lambda code scanning together with Lambda standard scanning (see [Inspector.4] Amazon Inspector Lambda standard scanning should be enabled).

This rule is covered by the [inspector-lambda-code-scan-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/inspector/inspector-lambda-code-scan-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # inspector-lambda-code-scan-enabled.policytest.hcl... running
      # resource.aws_inspector2_enabler.pass_lambda_code_only... running
      # resource.aws_inspector2_enabler.pass_lambda_code_only... pass
      # resource.aws_inspector2_enabler.pass_multiple_types_with_lambda_code... running
      # resource.aws_inspector2_enabler.pass_multiple_types_with_lambda_code... pass
      # resource.aws_inspector2_enabler.fail_no_lambda_code... running
      # resource.aws_inspector2_enabler.fail_no_lambda_code... pass
      # resource.aws_inspector2_enabler.fail_lambda_code_empty_resource_types... running
      # resource.aws_inspector2_enabler.fail_lambda_code_empty_resource_types... pass
      # resource.aws_inspector2_organization_configuration.pass_lambda_code_enabled... running
      # resource.aws_inspector2_organization_configuration.pass_lambda_code_enabled... pass
      # resource.aws_inspector2_organization_configuration.fail_lambda_code_disabled... running
      # resource.aws_inspector2_organization_configuration.fail_lambda_code_disabled... pass
      # resource.aws_inspector2_organization_configuration.fail_no_auto_enable... running
      # resource.aws_inspector2_organization_configuration.fail_no_auto_enable... pass
      # resource.aws_inspector2_organization_configuration.fail_no_lambda_code_config... running
      # resource.aws_inspector2_organization_configuration.fail_no_lambda_code_config... pass
      # resource.aws_inspector2_organization_configuration.fail_lambda_lambda_code_disabled... running
      # resource.aws_inspector2_organization_configuration.fail_lambda_lambda_code_disabled... pass
      # inspector-lambda-code-scan-enabled.policytest.hcl... pass
```

---
