# Ensure a log metric filter and alarm exist for changes to network gateways

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether a log metric filter and alarm exist for changes to network gateways.

Gateways are the doors between a VPC and everything outside it. Creating or re-attaching one can give a previously isolated subnet a route to the internet, which is a common step in establishing exfiltration paths.

The policy requires a metric filter matching `CreateCustomerGateway`, `DeleteCustomerGateway`, `AttachInternetGateway`, `CreateInternetGateway`, `DeleteInternetGateway`, and `DetachInternetGateway`. The policy also requires the supporting delivery chain to be in place: a multi-Region CloudTrail trail with logging enabled that delivers events to a CloudWatch Logs group, a metric filter that emits a named metric with `value = "1"` and `default_value = "0"`, an alarm that references that metric by both name and namespace using `GreaterThanOrEqualToThreshold` with a threshold of `1`, and at least one alarm action pointing at a declared SNS topic that has a subscription. A filter without an alarm, or an alarm without a notification target, produces no actionable signal.

This rule is covered by the [cloudwatch-network-gateway-changes-alarm](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudwatch/cloudwatch-network-gateway-changes-alarm.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloudwatch-network-gateway-changes-alarm.policytest.hcl... running
      # resource.aws_sns_topic.pass_gateway_changes_topic... running
      # resource.aws_sns_topic.pass_gateway_changes_topic... pass
      # resource.aws_cloudwatch_log_metric_filter.pass_gateway_changes_filter... running
      # resource.aws_cloudwatch_log_metric_filter.pass_gateway_changes_filter... pass
      # resource.aws_cloudwatch_metric_alarm.pass_gateway_changes_alarm... running
      # resource.aws_cloudwatch_metric_alarm.pass_gateway_changes_alarm... pass
      # resource.aws_sns_topic_subscription.pass_gateway_changes_subscription... running
      # resource.aws_sns_topic_subscription.pass_gateway_changes_subscription... pass
      # resource.aws_cloudwatch_log_metric_filter.fail_missing_create_igw... running
      # resource.aws_cloudwatch_log_metric_filter.fail_missing_create_igw... pass
      # resource.aws_cloudwatch_log_metric_filter.fail_missing_attach_igw... running
      # resource.aws_cloudwatch_log_metric_filter.fail_missing_attach_igw... pass
      # resource.aws_cloudwatch_log_metric_filter.fail_missing_default_value... running
      # resource.aws_cloudwatch_log_metric_filter.fail_missing_default_value... pass
      # resource.aws_cloudwatch_metric_alarm.fail_wrong_metric... running
      # resource.aws_cloudwatch_metric_alarm.fail_wrong_metric... pass
      # resource.aws_cloudwatch_metric_alarm.fail_wrong_namespace... running
      # resource.aws_cloudwatch_metric_alarm.fail_wrong_namespace... pass
      # resource.aws_cloudwatch_metric_alarm.fail_no_alarm_actions... running
      # resource.aws_cloudwatch_metric_alarm.fail_no_alarm_actions... pass
      # resource.aws_cloudwatch_metric_alarm.fail_zero_threshold... running
      # resource.aws_cloudwatch_metric_alarm.fail_zero_threshold... pass
      # resource.aws_sns_topic_subscription.fail_undeclared_topic... running
      # resource.aws_sns_topic_subscription.fail_undeclared_topic... pass
      # resource.aws_sns_topic_subscription.fail_unlinked_subscription... running
      # resource.aws_sns_topic_subscription.fail_unlinked_subscription... pass
      # resource.aws_cloudtrail.pass_network_gateway_changes_trail... running
      # resource.aws_cloudtrail.pass_network_gateway_changes_trail... pass
      # resource.aws_cloudtrail.fail_no_cloudwatch_logs... running
      # resource.aws_cloudtrail.fail_no_cloudwatch_logs... pass
      # resource.aws_cloudtrail.fail_logging_disabled... running
      # resource.aws_cloudtrail.fail_logging_disabled... pass
      # resource.aws_cloudtrail.fail_no_cloudwatch_logs_role... running
      # resource.aws_cloudtrail.fail_no_cloudwatch_logs_role... pass
      # resource.aws_cloudtrail.fail_single_region_trail... running
      # resource.aws_cloudtrail.fail_single_region_trail... pass
      # cloudwatch-network-gateway-changes-alarm.policytest.hcl... pass
```

---
