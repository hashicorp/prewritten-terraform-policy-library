# Ensure a log metric filter and alarm exist for root user usage

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether a log metric filter and alarm exist for usage of the root user.

The root user has unrestricted access to every resource and every billing function in an account, and its permissions cannot be constrained by IAM policy. Routine work should never require it, so any root activity is either a break-glass event or a compromise — both of which warrant an immediate alert.

The policy requires a metric filter whose pattern matches on `userIdentity.type` being `Root`. The policy also requires the supporting delivery chain to be in place: a multi-Region CloudTrail trail with logging enabled that delivers events to a CloudWatch Logs group, a metric filter that emits a named metric with `value = "1"` and `default_value = "0"`, an alarm that references that metric by both name and namespace using `GreaterThanOrEqualToThreshold` with a threshold of `1`, and at least one alarm action pointing at a declared SNS topic that has a subscription. A filter without an alarm, or an alarm without a notification target, produces no actionable signal.

This rule is covered by the [cloudwatch-root-user-activity-alarm](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudwatch/cloudwatch-root-user-activity-alarm.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloudwatch-root-user-activity-alarm.policytest.hcl... running
      # resource.aws_sns_topic.pass_root_user_activity_topic... running
      # resource.aws_sns_topic.pass_root_user_activity_topic... pass
      # resource.aws_cloudwatch_log_metric_filter.pass_root_filter... running
      # resource.aws_cloudwatch_log_metric_filter.pass_root_filter... pass
      # resource.aws_cloudwatch_metric_alarm.pass_upper_threshold... running
      # resource.aws_cloudwatch_metric_alarm.pass_upper_threshold... pass
      # resource.aws_sns_topic_subscription.pass_linked_subscription... running
      # resource.aws_sns_topic_subscription.pass_linked_subscription... pass
      # resource.aws_cloudwatch_log_metric_filter.fail_non_root_filter... running
      # resource.aws_cloudwatch_log_metric_filter.fail_non_root_filter... pass
      # resource.aws_cloudwatch_log_metric_filter.fail_missing_default_value... running
      # resource.aws_cloudwatch_log_metric_filter.fail_missing_default_value... pass
      # resource.aws_cloudwatch_metric_alarm.pass_lower_threshold... running
      # resource.aws_cloudwatch_metric_alarm.pass_lower_threshold... pass
      # resource.aws_cloudwatch_metric_alarm.fail_unlinked_metric... running
      # resource.aws_cloudwatch_metric_alarm.fail_unlinked_metric... pass
      # resource.aws_cloudwatch_metric_alarm.fail_wrong_namespace... running
      # resource.aws_cloudwatch_metric_alarm.fail_wrong_namespace... pass
      # resource.aws_cloudwatch_metric_alarm.fail_threshold_above_range... running
      # resource.aws_cloudwatch_metric_alarm.fail_threshold_above_range... pass
      # resource.aws_cloudwatch_metric_alarm.fail_wrong_comparison... running
      # resource.aws_cloudwatch_metric_alarm.fail_wrong_comparison... pass
      # resource.aws_cloudwatch_metric_alarm.fail_empty_actions... running
      # resource.aws_cloudwatch_metric_alarm.fail_empty_actions... pass
      # resource.aws_sns_topic_subscription.fail_undeclared_topic... running
      # resource.aws_sns_topic_subscription.fail_undeclared_topic... pass
      # resource.aws_sns_topic_subscription.fail_unlinked_subscription... running
      # resource.aws_sns_topic_subscription.fail_unlinked_subscription... pass
      # resource.aws_cloudtrail.pass_root_user_activity_trail... running
      # resource.aws_cloudtrail.pass_root_user_activity_trail... pass
      # resource.aws_cloudtrail.fail_no_cloudwatch_logs... running
      # resource.aws_cloudtrail.fail_no_cloudwatch_logs... pass
      # resource.aws_cloudtrail.fail_logging_disabled... running
      # resource.aws_cloudtrail.fail_logging_disabled... pass
      # resource.aws_cloudtrail.fail_no_cloudwatch_logs_role... running
      # resource.aws_cloudtrail.fail_no_cloudwatch_logs_role... pass
      # resource.aws_cloudtrail.fail_single_region_trail... running
      # resource.aws_cloudtrail.fail_single_region_trail... pass
      # cloudwatch-root-user-activity-alarm.policytest.hcl... pass
```

---
