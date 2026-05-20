# Amazon Inspector EC2 scanning should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether Amazon Inspector EC2 scanning is enabled. For a standalone account, the control fails if Amazon Inspector EC2 scanning is disabled in the account. In a multi-account environment, the control fails if the delegated Amazon Inspector administrator account and all member accounts don't have EC2 scanning enabled.

In a multi-account environment, the control generates findings in only the delegated Amazon Inspector administrator account. Only the delegated administrator can enable or disable the EC2 scanning feature for the member accounts in the organization. Amazon Inspector member accounts can't modify this configuration from their accounts. This control generates FAILED findings if the delegated administrator has a suspended member account that doesn't have Amazon Inspector EC2 scanning enabled. To receive a PASSED finding, the delegated administrator must disassociate these suspended accounts in Amazon Inspector.

Amazon Inspector EC2 scanning extracts metadata from your Amazon Elastic Compute Cloud (Amazon EC2) instance, and then compares this metadata against rules collected from security advisories to produce findings. Amazon Inspector scans instances for package vulnerabilities and network reachability issues. For information about supported operating systems, including which operating system can be scanned without an SSM agent, see Supported operating systems: Amazon EC2 scanning.

This rule is covered by the [inspector-ec2-scan-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/inspector/inspector-ec2-scan-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # inspector-ec2-scan-enabled.policytest.hcl... running
      # resource.aws_inspector2_enabler.pass_ec2_only... running
      # resource.aws_inspector2_enabler.pass_ec2_only... pass
      # resource.aws_inspector2_enabler.pass_multiple_types_with_ec2... running
      # resource.aws_inspector2_enabler.pass_multiple_types_with_ec2... pass
      # resource.aws_inspector2_enabler.fail_no_ec2... running
      # resource.aws_inspector2_enabler.fail_no_ec2... pass
      # resource.aws_inspector2_enabler.fail_empty_resource_types... running
      # resource.aws_inspector2_enabler.fail_empty_resource_types... pass
      # resource.aws_inspector2_organization_configuration.pass_ec2_enabled... running
      # resource.aws_inspector2_organization_configuration.pass_ec2_enabled... pass
      # resource.aws_inspector2_organization_configuration.fail_ec2_disabled... running
      # resource.aws_inspector2_organization_configuration.fail_ec2_disabled... pass
      # resource.aws_inspector2_organization_configuration.fail_no_auto_enable... running
      # resource.aws_inspector2_organization_configuration.fail_no_auto_enable... pass
      # resource.aws_inspector2_organization_configuration.fail_no_ec2_config... running
      # resource.aws_inspector2_organization_configuration.fail_no_ec2_config... pass
      # inspector-ec2-scan-enabled.policytest.hcl... pass
```

---
