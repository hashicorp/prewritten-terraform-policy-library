# Ensure AWS Organizations changes are monitored

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether a log metric filter and alarm exist for changes to AWS Organizations.

Organizations governs account membership and the service control policies that cap what every account in the organization may do. Removing an account from an organization, or detaching an SCP, can strip away guardrails across an entire environment in one call.

The policy requires a metric filter scoped to `organizations.amazonaws.com` matching the organization, policy, and account membership events, including `AcceptHandshake`, `AttachPolicy`, `CreateAccount`, `CreateOrganizationalUnit`, `CreatePolicy`, `DeclineHandshake`, `DeleteOrganization`, `DeleteOrganizationalUnit`, `DeletePolicy`, `DetachPolicy`, `DisablePolicyType`, `EnablePolicyType`, `InviteAccountToOrganization`, `LeaveOrganization`, `MoveAccount`, `RemoveAccountFromOrganization`, `UpdatePolicy`, and `UpdateOrganizationalUnit`. The policy also requires the supporting delivery chain to be in place: a multi-Region CloudTrail trail with logging enabled that delivers events to a CloudWatch Logs group, a metric filter that emits a named metric with `value = "1"` and `default_value = "0"`, an alarm that references that metric by both name and namespace using `GreaterThanOrEqualToThreshold` with a threshold of `1`, and at least one alarm action pointing at a declared SNS topic that has a subscription. A filter without an alarm, or an alarm without a notification target, produces no actionable signal.

This rule is covered by the [cloudwatch-organizations-changes-alarm](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudwatch/cloudwatch-organizations-changes-alarm.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloudwatch-organizations-changes-alarm.policytest.hcl... running
      # resource.aws_sns_topic.pass_org_changes_topic... running
      # resource.aws_sns_topic.pass_org_changes_topic... pass
      # resource.aws_cloudwatch_log_metric_filter.pass_org_changes_filter... running
      # resource.aws_cloudwatch_log_metric_filter.pass_org_changes_filter... pass
      # resource.aws_cloudwatch_metric_alarm.pass_org_changes_alarm... running
      # resource.aws_cloudwatch_metric_alarm.pass_org_changes_alarm... pass
      # resource.aws_sns_topic_subscription.pass_org_changes_subscription... running
      # resource.aws_sns_topic_subscription.pass_org_changes_subscription... pass
      # resource.aws_cloudwatch_log_metric_filter.fail_missing_org_source... running
      # resource.aws_cloudwatch_log_metric_filter.fail_missing_org_source... pass
      # resource.aws_cloudwatch_log_metric_filter.fail_missing_move_account... running
      # resource.aws_cloudwatch_log_metric_filter.fail_missing_move_account... pass
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
      # resource.aws_cloudtrail.pass_org_changes_trail... running
      # resource.aws_cloudtrail.pass_org_changes_trail... pass
      # resource.aws_cloudtrail.fail_no_cloudwatch_logs... running
      # resource.aws_cloudtrail.fail_no_cloudwatch_logs... pass
      # resource.aws_cloudtrail.fail_logging_disabled... running
      # resource.aws_cloudtrail.fail_logging_disabled... pass
      # resource.aws_cloudtrail.fail_no_cloudwatch_logs_role... running
      # resource.aws_cloudtrail.fail_no_cloudwatch_logs_role... pass
      # resource.aws_cloudtrail.fail_single_region_trail... running
      # resource.aws_cloudtrail.fail_single_region_trail... pass
      # cloudwatch-organizations-changes-alarm.policytest.hcl... pass
```

---
