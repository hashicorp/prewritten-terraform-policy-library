# GuardDuty should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether Amazon GuardDuty is enabled in your GuardDuty account and Region.

It is highly recommended that you enable GuardDuty in all supported AWS Regions. Doing so allows GuardDuty to generate findings about unauthorized or unusual activity, even in Regions that you do not actively use. This also allows GuardDuty to monitor CloudTrail events for global AWS services such as IAM.

This rule is covered by the [guardduty-enabled-centralized](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/guardduty/guardduty-enabled-centralized.policy.hcl) policy.

## Policy Results

```bash
trace:
      # guardduty-enabled-centralized.policytest.hcl... running
      # resource.aws_guardduty_detector.pass_explicitly_enabled... running
      # resource.aws_guardduty_detector.pass_explicitly_enabled... pass
      # resource.aws_guardduty_detector.fail_explicitly_disabled... running
      # resource.aws_guardduty_detector.fail_explicitly_disabled... pass
      # resource.aws_guardduty_detector.pass_enable_not_specified... running
      # resource.aws_guardduty_detector.pass_enable_not_specified... pass
      # guardduty-enabled-centralized.policytest.hcl... pass
```

---
