# Ensure a log metric filter and alarm exist for unauthorized API calls

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether a log metric filter and alarm exist for unauthorized API calls.

A burst of `AccessDenied` or `UnauthorizedOperation` responses is one of the clearest signatures of credential misuse: an attacker probing the blast radius of a stolen key, or automation running with permissions it should not have. Alerting on these calls surfaces the activity while it is still failing, rather than after a privilege escalation succeeds.

The policy requires a metric filter that matches `errorCode` values of `*UnauthorizedOperation` and `AccessDenied*`. The policy also requires the supporting delivery chain to be in place: a multi-Region CloudTrail trail with logging enabled that delivers events to a CloudWatch Logs group, a metric filter that emits a named metric with `value = "1"` and `default_value = "0"`, an alarm that references that metric by both name and namespace using `GreaterThanOrEqualToThreshold` with a threshold of `1`, and at least one alarm action pointing at a declared SNS topic that has a subscription. A filter without an alarm, or an alarm without a notification target, produces no actionable signal.

This rule is covered by the [cloudwatch-unauthorised-api-alarm](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudwatch/cloudwatch-unauthorised-api-alarm.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloudwatch-unauthorised-api-alarm.policytest.hcl... running
      # resource.aws_cloudtrail.cloudwatch_2_pass... running
      # resource.aws_cloudtrail.cloudwatch_2_pass... pass
      # resource.aws_cloudwatch_log_metric_filter.cloudwatch_2_pass... running
      # resource.aws_cloudwatch_log_metric_filter.cloudwatch_2_pass... pass
      # resource.aws_cloudwatch_metric_alarm.cloudwatch_2_pass... running
      # resource.aws_cloudwatch_metric_alarm.cloudwatch_2_pass... pass
      # resource.aws_sns_topic_subscription.cloudwatch_2_pass... running
      # resource.aws_sns_topic_subscription.cloudwatch_2_pass... pass
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
      # cloudwatch-unauthorised-api-alarm.policytest.hcl... pass
```

---
