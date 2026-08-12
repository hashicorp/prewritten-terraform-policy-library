# Amazon Inspector ECR scanning should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether Amazon Inspector ECR scanning is enabled. For a standalone account, the control fails if Amazon Inspector ECR scanning is disabled in the account. In a multi-account environment, the control fails if the delegated Amazon Inspector administrator account and all member accounts don't have ECR scanning enabled.

In a multi-account environment, the control generates findings in only the delegated Amazon Inspector administrator account. Only the delegated administrator can enable or disable the ECR scanning feature for the member accounts in the organization. Amazon Inspector member accounts can't modify this configuration from their accounts. This control generates FAILED findings if the delegated administrator has a suspended member account that doesn't have Amazon Inspector ECR scanning enabled. To receive a PASSED finding, the delegated administrator must disassociate these suspended accounts in Amazon Inspector.

Amazon Inspector scans container images stored in Amazon Elastic Container Registry (Amazon ECR) for software vulnerabilities to generate package vulnerability findings. When you activate Amazon Inspector scans for Amazon ECR, you set Amazon Inspector as your preferred scanning service for your private registry. This replaces basic scanning, which is provided at no charge by Amazon ECR, with enhanced scanning, which is provided and billed through Amazon Inspector. Enhanced scanning gives you the benefit of vulnerability scanning for both operating system and programming language packages at the registry level. You can review findings discovered using enhanced scanning at the image level, for each layer of the image, on the Amazon ECR console. Additionally, you can review and work with these findings in other services not available for basic scanning findings, including AWS Security Hub CSPM and Amazon EventBridge.

This rule is covered by the [inspector-ecr-scan-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/inspector/inspector-ecr-scan-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # inspector-ecr-scan-enabled.policytest.hcl... running
      # resource.aws_inspector2_enabler.pass_ecr_only... running
      # resource.aws_inspector2_enabler.pass_ecr_only... pass
      # resource.aws_inspector2_enabler.pass_multiple_types_with_ecr... running
      # resource.aws_inspector2_enabler.pass_multiple_types_with_ecr... pass
      # resource.aws_inspector2_enabler.fail_no_ecr... running
      # resource.aws_inspector2_enabler.fail_no_ecr... pass
      # resource.aws_inspector2_enabler.fail_ecr_empty_resource_types... running
      # resource.aws_inspector2_enabler.fail_ecr_empty_resource_types... pass
      # resource.aws_inspector2_organization_configuration.pass_ecr_enabled... running
      # resource.aws_inspector2_organization_configuration.pass_ecr_enabled... pass
      # resource.aws_inspector2_organization_configuration.fail_ecr_disabled... running
      # resource.aws_inspector2_organization_configuration.fail_ecr_disabled... pass
      # resource.aws_inspector2_organization_configuration.fail_no_auto_enable... running
      # resource.aws_inspector2_organization_configuration.fail_no_auto_enable... pass
      # resource.aws_inspector2_organization_configuration.fail_no_ecr_config... running
      # resource.aws_inspector2_organization_configuration.fail_no_ecr_config... pass
      # inspector-ecr-scan-enabled.policytest.hcl... pass
```

---
