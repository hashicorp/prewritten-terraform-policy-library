# Ensure a log metric filter and alarm exist for Management Console sign-in without MFA

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether a log metric filter and alarm exist for AWS Management Console sign-ins that are not protected by multi-factor authentication.

A console session established with only a password is a session protected by a single, phishable factor. Alerting on these sign-ins catches both accounts that were never enrolled in MFA and cases where MFA enforcement has been removed or bypassed.

The policy requires a metric filter that matches `ConsoleLogin` events where MFA was not used. The policy also requires the supporting delivery chain to be in place: a multi-Region CloudTrail trail with logging enabled that delivers events to a CloudWatch Logs group, a metric filter that emits a named metric with `value = "1"` and `default_value = "0"`, an alarm that references that metric by both name and namespace using `GreaterThanOrEqualToThreshold` with a threshold of `1`, and at least one alarm action pointing at a declared SNS topic that has a subscription. A filter without an alarm, or an alarm without a notification target, produces no actionable signal.

This rule is covered by the [cloudwatch-mfa-signin-alarm](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudwatch/cloudwatch-mfa-signin-alarm.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloudwatch-mfa-signin-alarm.policytest.hcl... running
      # resource.aws_cloudtrail.cloudwatch_3_pass... running
      # resource.aws_cloudtrail.cloudwatch_3_pass... pass
      # resource.aws_cloudwatch_log_metric_filter.cloudwatch_3_pass... running
      # resource.aws_cloudwatch_log_metric_filter.cloudwatch_3_pass... pass
      # resource.aws_cloudwatch_metric_alarm.cloudwatch_3_pass... running
      # resource.aws_cloudwatch_metric_alarm.cloudwatch_3_pass... pass
      # resource.aws_sns_topic_subscription.cloudwatch_3_pass... running
      # resource.aws_sns_topic_subscription.cloudwatch_3_pass... pass
      # resource.aws_cloudtrail.single_region_trail... running
      # resource.aws_cloudtrail.single_region_trail... pass
      # resource.aws_cloudtrail.logging_disabled... running
      # resource.aws_cloudtrail.logging_disabled... pass
      # resource.aws_cloudtrail.no_cloudwatch_logs_group_arn... running
      # resource.aws_cloudtrail.no_cloudwatch_logs_group_arn... pass
      # resource.aws_cloudtrail.no_cloudwatch_logs_role_arn... running
      # resource.aws_cloudtrail.no_cloudwatch_logs_role_arn... pass
      # resource.aws_cloudtrail.log_group_not_found... running
      # resource.aws_cloudtrail.log_group_not_found... pass
      # resource.aws_cloudwatch_metric_alarm.log_group_not_found... running
      # resource.aws_cloudwatch_metric_alarm.log_group_not_found... pass
      # resource.aws_sns_topic_subscription.log_group_not_found... running
      # resource.aws_sns_topic_subscription.log_group_not_found... pass
      # resource.aws_cloudtrail.no_metric_filter... running
      # resource.aws_cloudtrail.no_metric_filter... pass
      # resource.aws_cloudwatch_metric_alarm.no_metric_filter... running
      # resource.aws_cloudwatch_metric_alarm.no_metric_filter... pass
      # resource.aws_sns_topic_subscription.no_metric_filter... running
      # resource.aws_sns_topic_subscription.no_metric_filter... pass
      # resource.aws_cloudtrail.incorrect_metric_pattern... running
      # resource.aws_cloudtrail.incorrect_metric_pattern... pass
      # resource.aws_cloudwatch_log_metric_filter.incorrect_metric_pattern... running
      # resource.aws_cloudwatch_log_metric_filter.incorrect_metric_pattern... pass
      # resource.aws_cloudwatch_metric_alarm.incorrect_metric_pattern... running
      # resource.aws_cloudwatch_metric_alarm.incorrect_metric_pattern... pass
      # resource.aws_sns_topic_subscription.incorrect_metric_pattern... running
      # resource.aws_sns_topic_subscription.incorrect_metric_pattern... pass
      # resource.aws_cloudtrail.wrong_metric_namespace... running
      # resource.aws_cloudtrail.wrong_metric_namespace... pass
      # resource.aws_cloudwatch_log_metric_filter.wrong_metric_namespace... running
      # resource.aws_cloudwatch_log_metric_filter.wrong_metric_namespace... pass
      # resource.aws_cloudwatch_metric_alarm.wrong_metric_namespace... running
      # resource.aws_cloudwatch_metric_alarm.wrong_metric_namespace... pass
      # resource.aws_sns_topic_subscription.wrong_metric_namespace... running
      # resource.aws_sns_topic_subscription.wrong_metric_namespace... pass
      # resource.aws_cloudtrail.wrong_metric_value... running
      # resource.aws_cloudtrail.wrong_metric_value... pass
      # resource.aws_cloudwatch_log_metric_filter.wrong_metric_value... running
      # resource.aws_cloudwatch_log_metric_filter.wrong_metric_value... pass
      # resource.aws_cloudwatch_metric_alarm.wrong_metric_value... running
      # resource.aws_cloudwatch_metric_alarm.wrong_metric_value... pass
      # resource.aws_sns_topic_subscription.wrong_metric_value... running
      # resource.aws_sns_topic_subscription.wrong_metric_value... pass
      # resource.aws_cloudtrail.wrong_metric_default_value... running
      # resource.aws_cloudtrail.wrong_metric_default_value... pass
      # resource.aws_cloudwatch_log_metric_filter.wrong_metric_default_value... running
      # resource.aws_cloudwatch_log_metric_filter.wrong_metric_default_value... pass
      # resource.aws_cloudwatch_metric_alarm.wrong_metric_default_value... running
      # resource.aws_cloudwatch_metric_alarm.wrong_metric_default_value... pass
      # resource.aws_sns_topic_subscription.wrong_metric_default_value... running
      # resource.aws_sns_topic_subscription.wrong_metric_default_value... pass
      # resource.aws_cloudtrail.wrong_comparison_operator... running
      # resource.aws_cloudtrail.wrong_comparison_operator... pass
      # resource.aws_cloudwatch_log_metric_filter.wrong_comparison_operator... running
      # resource.aws_cloudwatch_log_metric_filter.wrong_comparison_operator... pass
      # resource.aws_cloudwatch_metric_alarm.wrong_comparison_operator... running
      # resource.aws_cloudwatch_metric_alarm.wrong_comparison_operator... pass
      # resource.aws_sns_topic_subscription.wrong_comparison_operator... running
      # resource.aws_sns_topic_subscription.wrong_comparison_operator... pass
      # resource.aws_cloudtrail.wrong_alarm_threshold... running
      # resource.aws_cloudtrail.wrong_alarm_threshold... pass
      # resource.aws_cloudwatch_log_metric_filter.wrong_alarm_threshold... running
      # resource.aws_cloudwatch_log_metric_filter.wrong_alarm_threshold... pass
      # resource.aws_cloudwatch_metric_alarm.wrong_alarm_threshold... running
      # resource.aws_cloudwatch_metric_alarm.wrong_alarm_threshold... pass
      # resource.aws_sns_topic_subscription.wrong_alarm_threshold... running
      # resource.aws_sns_topic_subscription.wrong_alarm_threshold... pass
      # resource.aws_cloudtrail.no_sns_topic_in_alarm... running
      # resource.aws_cloudtrail.no_sns_topic_in_alarm... pass
      # resource.aws_cloudwatch_log_metric_filter.no_sns_topic_in_alarm... running
      # resource.aws_cloudwatch_log_metric_filter.no_sns_topic_in_alarm... pass
      # resource.aws_cloudwatch_metric_alarm.no_sns_topic_in_alarm... running
      # resource.aws_cloudwatch_metric_alarm.no_sns_topic_in_alarm... pass
      # resource.aws_sns_topic_subscription.no_sns_topic_in_alarm... running
      # resource.aws_sns_topic_subscription.no_sns_topic_in_alarm... pass
      # resource.aws_cloudtrail.sns_no_subscriptions... running
      # resource.aws_cloudtrail.sns_no_subscriptions... pass
      # resource.aws_cloudwatch_log_metric_filter.sns_no_subscriptions... running
      # resource.aws_cloudwatch_log_metric_filter.sns_no_subscriptions... pass
      # resource.aws_cloudwatch_metric_alarm.sns_no_subscriptions... running
      # resource.aws_cloudwatch_metric_alarm.sns_no_subscriptions... pass
      # resource.aws_sns_topic_subscription.sns_no_subscriptions... running
      # resource.aws_sns_topic_subscription.sns_no_subscriptions... pass
      # cloudwatch-mfa-signin-alarm.policytest.hcl... pass
```

---
