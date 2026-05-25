# GuardDuty EC2 Runtime Monitoring should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection Services |

## Description

This control checks whether the Amazon GuardDuty automated security agent is enabled for runtime monitoring of Amazon EC2 instances. For a standalone account, the control fails if the security agent is disabled for the account. In a multi-account environment, the control fails if the security agent is disabled for the delegated GuardDuty administrator account and all member accounts.

In a multi-account environment, this control generates findings only in the delegated GuardDuty administrator account. This is because only the delegated GuardDuty administrator can enable or disable Runtime Monitoring of Amazon EC2 instances for accounts in their organization. GuardDuty member accounts can't do this for their own accounts. In addition, this control generates FAILED findings if GuardDuty is suspended for a member account and Runtime Monitoring of EC2 instances is disabled for the member account. To receive a PASSED finding, the GuardDuty administrator must disassociate the suspended member account from their administrator account by using GuardDuty.

GuardDuty Runtime Monitoring observes and analyzes operating system-level, networking, and file events to help you detect potential threats in specific AWS workloads in your environment. It uses GuardDuty security agents that add visibility into runtime behavior, such as file access, process execution, command line arguments, and network connections. You can enable and manage the security agent for each type of resource that you want to monitor for potential threats. This includes Amazon EC2 instances.

This rule is covered by the [guardduty-ec2-protection-runtime-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/guardduty/guardduty-ec2-protection-runtime-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # guardduty-ec2-protection-runtime-enabled.policytest.hcl... running
      # resource.aws_guardduty_detector_feature.pass_runtime_monitoring_with_ec2_agent... running
      # resource.aws_guardduty_detector_feature.pass_runtime_monitoring_with_ec2_agent... pass
      # resource.aws_guardduty_detector_feature.fail_runtime_monitoring_disabled... running
      # resource.aws_guardduty_detector_feature.fail_runtime_monitoring_disabled... pass
      # resource.aws_guardduty_detector_feature.fail_ec2_agent_disabled... running
      # resource.aws_guardduty_detector_feature.fail_ec2_agent_disabled... pass
      # resource.aws_guardduty_detector_feature.fail_no_additional_config... running
      # resource.aws_guardduty_detector_feature.fail_no_additional_config... pass
      # resource.aws_guardduty_detector_feature.fail_empty_additional_config... running
      # resource.aws_guardduty_detector_feature.fail_empty_additional_config... pass
      # resource.aws_guardduty_detector_feature.skip_other_feature_types... running
      # resource.aws_guardduty_detector_feature.skip_other_feature_types... pass
      # resource.aws_guardduty_organization_configuration_feature.pass_org_runtime_monitoring_with_ec2_agent... running
      # resource.aws_guardduty_organization_configuration_feature.pass_org_runtime_monitoring_with_ec2_agent... pass
      # resource.aws_guardduty_organization_configuration_feature.fail_org_runtime_monitoring_disabled... running
      # resource.aws_guardduty_organization_configuration_feature.fail_org_runtime_monitoring_disabled... pass
      # resource.aws_guardduty_organization_configuration_feature.fail_org_ec2_agent_disabled... running
      # resource.aws_guardduty_organization_configuration_feature.fail_org_ec2_agent_disabled... pass
      # resource.aws_guardduty_organization_configuration_feature.fail_org_no_additional_config... running
      # resource.aws_guardduty_organization_configuration_feature.fail_org_no_additional_config... pass
      # resource.aws_guardduty_organization_configuration_feature.fail_org_empty_additional_config... running
      # resource.aws_guardduty_organization_configuration_feature.fail_org_empty_additional_config... pass
      # guardduty-ec2-protection-runtime-enabled.policytest.hcl... pass
```

---
