# GuardDuty Runtime Monitoring should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection Services |

## Description

This control checks whether Runtime Monitoring is enabled in Amazon GuardDuty. For a standalone account, the control fails if GuardDuty Runtime Monitoring is disabled for the account. In a multi-account environment, the control fails if GuardDuty Runtime Monitoring is disabled for the delegated GuardDuty administrator account and all member accounts.

In a multi-account environment, only the delegated GuardDuty administrator can enable or disable GuardDuty Runtime Monitoring for accounts in their organization. In addition, only the GuardDuty administrator can configure and manage the security agents that GuardDuty uses for runtime monitoring of AWS workloads and resources for accounts in the organization. GuardDuty member accounts can't enable, configure, or disable Runtime Monitoring for their own accounts.

GuardDuty Runtime Monitoring observes and analyzes operating system-level, networking, and file events to help you detect potential threats in specific AWS workloads in your environment. It uses GuardDuty security agents that add visibility into runtime behavior, such as file access, process execution, command line arguments, and network connections. You can enable and manage the security agent for each type of resource that you want to monitor for potential threats, such as Amazon EKS clusters and Amazon EC2 instances.

This rule is covered by the [guardduty-runtime-monitoring-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/guardduty/guardduty-runtime-monitoring-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # guardduty-runtime-monitoring-enabled.policytest.hcl... running
      # resource.aws_guardduty_detector_feature.pass_runtime_ec2... running
      # resource.aws_guardduty_detector_feature.pass_runtime_ec2... pass
      # resource.aws_guardduty_detector_feature.pass_runtime_ecs... running
      # resource.aws_guardduty_detector_feature.pass_runtime_ecs... pass
      # resource.aws_guardduty_detector_feature.pass_runtime_eks... running
      # resource.aws_guardduty_detector_feature.pass_runtime_eks... pass
      # resource.aws_guardduty_detector_feature.pass_runtime_multiple... running
      # resource.aws_guardduty_detector_feature.pass_runtime_multiple... pass
      # resource.aws_guardduty_detector_feature.fail_runtime_disabled... running
      # resource.aws_guardduty_detector_feature.fail_runtime_disabled... pass
      # resource.aws_guardduty_detector_feature.fail_runtime_no_config... running
      # resource.aws_guardduty_detector_feature.fail_runtime_no_config... pass
      # resource.aws_guardduty_detector_feature.fail_runtime_all_disabled... running
      # resource.aws_guardduty_detector_feature.fail_runtime_all_disabled... pass
      # resource.aws_guardduty_organization_configuration_feature.pass_org_runtime... running
      # resource.aws_guardduty_organization_configuration_feature.pass_org_runtime... pass
      # resource.aws_guardduty_organization_configuration_feature.fail_org_runtime... running
      # resource.aws_guardduty_organization_configuration_feature.fail_org_runtime... pass
      # resource.aws_guardduty_organization_configuration_feature.fail_org_runtime_addon_disabled... running
      # resource.aws_guardduty_organization_configuration_feature.fail_org_runtime_addon_disabled... pass
      # resource.aws_guardduty_organization_configuration_feature.fail_org_runtime_no_addon... running
      # resource.aws_guardduty_organization_configuration_feature.fail_org_runtime_no_addon... pass
      # resource.aws_guardduty_detector_feature.pass_different_feature_filtered... running
      # resource.aws_guardduty_detector_feature.pass_different_feature_filtered... pass
      # guardduty-runtime-monitoring-enabled.policytest.hcl... pass
```

---
