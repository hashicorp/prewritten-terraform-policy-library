# Ensure a log metric filter and alarm exist for disabling or scheduled deletion of customer managed keys

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether a log metric filter and alarm exist for the disabling or scheduled deletion of customer managed KMS keys.

Disabling or deleting a KMS key renders everything encrypted under it permanently unreadable. KMS enforces a waiting period before deletion completes, and that window is only useful if someone is told the deletion was scheduled.

The policy requires a metric filter scoped to `kms.amazonaws.com` that matches `DisableKey` and `ScheduleKeyDeletion`. The policy also requires the supporting delivery chain to be in place: a multi-Region CloudTrail trail with logging enabled that delivers events to a CloudWatch Logs group, a metric filter that emits a named metric with `value = "1"` and `default_value = "0"`, an alarm that references that metric by both name and namespace using `GreaterThanOrEqualToThreshold` with a threshold of `1`, and at least one alarm action pointing at a declared SNS topic that has a subscription. A filter without an alarm, or an alarm without a notification target, produces no actionable signal.

This rule is covered by the [cloudwatch-customer-managed-key-deletion-alarm](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudwatch/cloudwatch-customer-managed-key-deletion-alarm.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloudwatch-customer-managed-key-deletion-alarm.policytest.hcl... running
      # resource.aws_sns_topic.pass_kms_deletion_topic... running
      # resource.aws_sns_topic.pass_kms_deletion_topic... pass
      # resource.aws_cloudwatch_log_metric_filter.pass_kms_deletion_filter... running
      # resource.aws_cloudwatch_log_metric_filter.pass_kms_deletion_filter... pass
      # resource.aws_cloudwatch_metric_alarm.pass_kms_deletion_alarm... running
      # resource.aws_cloudwatch_metric_alarm.pass_kms_deletion_alarm... pass
      # resource.aws_sns_topic_subscription.pass_kms_deletion_subscription... running
      # resource.aws_sns_topic_subscription.pass_kms_deletion_subscription... pass
      # resource.aws_cloudwatch_log_metric_filter.fail_missing_kms_source... running
      # resource.aws_cloudwatch_log_metric_filter.fail_missing_kms_source... pass
      # resource.aws_cloudwatch_log_metric_filter.fail_missing_schedule_deletion... running
      # resource.aws_cloudwatch_log_metric_filter.fail_missing_schedule_deletion... pass
      # resource.aws_cloudwatch_log_metric_filter.fail_missing_default_value... running
      # resource.aws_cloudwatch_log_metric_filter.fail_missing_default_value... pass
      # resource.aws_cloudwatch_metric_alarm.fail_wrong_metric... running
      # resource.aws_cloudwatch_metric_alarm.fail_wrong_metric... pass
      # resource.aws_cloudwatch_metric_alarm.fail_wrong_namespace... running
      # resource.aws_cloudwatch_metric_alarm.fail_wrong_namespace... pass
      # resource.aws_cloudwatch_metric_alarm.fail_zero_threshold... running
      # resource.aws_cloudwatch_metric_alarm.fail_zero_threshold... pass
      # resource.aws_cloudwatch_metric_alarm.fail_no_alarm_actions... running
      # resource.aws_cloudwatch_metric_alarm.fail_no_alarm_actions... pass
      # resource.aws_sns_topic_subscription.fail_undeclared_topic... running
      # resource.aws_sns_topic_subscription.fail_undeclared_topic... pass
      # resource.aws_sns_topic_subscription.fail_unlinked_subscription... running
      # resource.aws_sns_topic_subscription.fail_unlinked_subscription... pass
      # resource.aws_cloudtrail.pass_kms_deletion_trail... running
      # resource.aws_cloudtrail.pass_kms_deletion_trail... pass
      # resource.aws_cloudtrail.fail_no_cloudwatch_logs... running
      # resource.aws_cloudtrail.fail_no_cloudwatch_logs... pass
      # resource.aws_cloudtrail.fail_logging_disabled... running
      # resource.aws_cloudtrail.fail_logging_disabled... pass
      # resource.aws_cloudtrail.fail_no_cloudwatch_logs_role... running
      # resource.aws_cloudtrail.fail_no_cloudwatch_logs_role... pass
      # resource.aws_cloudtrail.fail_single_region_trail... running
      # resource.aws_cloudtrail.fail_single_region_trail... pass
      # cloudwatch-customer-managed-key-deletion-alarm.policytest.hcl... pass
```

---
