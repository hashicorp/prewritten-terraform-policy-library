# CloudWatch alarm actions should be activated

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Monitoring |

## Description

This control checks whether actions are enabled for Amazon CloudWatch metric alarms and composite alarms. The control fails if `actions_enabled` is explicitly set to `false`. When `actions_enabled` is omitted, the default value of `true` is assumed and the resource is considered compliant.

Enabling alarm actions ensures that CloudWatch alarms automatically trigger a response — such as sending an SNS notification or invoking an Auto Scaling policy — when an alarm state changes. Without active alarm actions, alarms may fire but no remediation or notification occurs, leaving operational and security incidents undetected. This applies to both `aws_cloudwatch_metric_alarm` and `aws_cloudwatch_composite_alarm` resource types.

This rule is covered by the [cloudwatch-alarm-actions-should-be-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudwatch/cloudwatch-alarm-actions-should-be-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloudwatch-alarm-actions-should-be-enabled.policytest.hcl...
      running
      # resource.aws_cloudwatch_metric_alarm.metric_enabled...
      running
      # resource.aws_cloudwatch_metric_alarm.metric_enabled...
      pass
      # resource.aws_cloudwatch_metric_alarm.metric_unset...
      running
      # resource.aws_cloudwatch_metric_alarm.metric_unset...
      pass
      # resource.aws_cloudwatch_metric_alarm.metric_disabled...
      running
      # resource.aws_cloudwatch_metric_alarm.metric_disabled...
      pass
      # resource.aws_cloudwatch_composite_alarm.composite_enabled...
      running
      # resource.aws_cloudwatch_composite_alarm.composite_enabled...
      pass
      # resource.aws_cloudwatch_composite_alarm.composite_unset...
      running
      # resource.aws_cloudwatch_composite_alarm.composite_unset...
      pass
      # resource.aws_cloudwatch_composite_alarm.composite_disabled...
      running
      # resource.aws_cloudwatch_composite_alarm.composite_disabled...
      pass
      # cloudwatch-alarm-actions-should-be-enabled.policytest.hcl...
      pass
```

---
