# Amazon Inspector Lambda standard scanning should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether Amazon Inspector Lambda standard scanning is enabled. For a standalone account, the control fails if Amazon Inspector Lambda standard scanning is disabled in the account. In a multi-account environment, the control fails if the delegated Amazon Inspector administrator account and all member accounts don't have Lambda standard scanning enabled.

In a multi-account environment, the control generates findings in only the delegated Amazon Inspector administrator account. Only the delegated administrator can enable or disable the Lambda standard scanning feature for the member accounts in the organization. Amazon Inspector member accounts can't modify this configuration from their accounts. This control generates FAILED findings if the delegated administrator has a suspended member account that doesn't have Amazon Inspector Lambda standard scanning enabled. To receive a PASSED finding, the delegated administrator must disassociate these suspended accounts in Amazon Inspector.

Amazon Inspector Lambda standard scanning identifies software vulnerabilities in the application package dependencies you add to your AWS Lambda function code and layers. If Amazon Inspector detects a vulnerability in your Lambda function application package dependencies, Amazon Inspector produces a detailed Package Vulnerability type finding. You can activate Lambda code scanning together with Lambda standard scanning (see [Inspector.3] Amazon Inspector Lambda code scanning should be enabled).

This rule is covered by the [inspector-lambda-standard-scan-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/inspector/inspector-lambda-standard-scan-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # inspector-lambda-standard-scan-enabled.policytest.hcl... running
      # resource.aws_inspector2_enabler.pass_lambda_only... running
      # resource.aws_inspector2_enabler.pass_lambda_only... pass
      # resource.aws_inspector2_enabler.pass_multiple_types_with_lambda... running
      # resource.aws_inspector2_enabler.pass_multiple_types_with_lambda... pass
      # resource.aws_inspector2_enabler.fail_no_lambda... running
      # resource.aws_inspector2_enabler.fail_no_lambda... pass
      # resource.aws_inspector2_enabler.fail_lambda_empty_resource_types... running
      # resource.aws_inspector2_enabler.fail_lambda_empty_resource_types... pass
      # resource.aws_inspector2_organization_configuration.pass_lambda_enabled... running
      # resource.aws_inspector2_organization_configuration.pass_lambda_enabled... pass
      # resource.aws_inspector2_organization_configuration.fail_lambda_disabled... running
      # resource.aws_inspector2_organization_configuration.fail_lambda_disabled... pass
      # resource.aws_inspector2_organization_configuration.fail_no_auto_enable... running
      # resource.aws_inspector2_organization_configuration.fail_no_auto_enable... pass
      # resource.aws_inspector2_organization_configuration.fail_no_lambda_config... running
      # resource.aws_inspector2_organization_configuration.fail_no_lambda_config... pass
      # inspector-lambda-standard-scan-enabled.policytest.hcl... pass
```

---
