# Existing RDS event notification subscriptions should be configured for critical cluster events

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Application monitoring |

## Description

This control checks whether an existing Amazon RDS event subscription for database clusters has notifications enabled for the following source type and event category key-value pairs:

DBCluster: ["maintenance","failure"]

The control passes if there are no existing event subscriptions in your account.

RDS event notifications uses Amazon SNS to make you aware of changes in the availability or configuration of your RDS resources. These notifications allow for rapid response. For additional information about RDS event notifications, see Using Amazon RDS event notification in the Amazon RDS User Guide.

This rule is covered by the [rds-cluster-event-notifications-configured](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-cluster-event-notifications-configured.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-cluster-event-notifications-configured.policytest.hcl... running
      # resource.aws_db_event_subscription.pass_with_both_categories_enabled... running
      # resource.aws_db_event_subscription.pass_with_both_categories_enabled... pass
      # resource.aws_db_event_subscription.pass_with_both_categories_default_enabled... running
      # resource.aws_db_event_subscription.pass_with_both_categories_default_enabled... pass
      # resource.aws_db_event_subscription.pass_with_all_categories... running
      # resource.aws_db_event_subscription.pass_with_all_categories... pass
      # resource.aws_db_event_subscription.fail_missing_failure_category... running
      # resource.aws_db_event_subscription.fail_missing_failure_category... pass
      # resource.aws_db_event_subscription.fail_missing_maintenance_category... running
      # resource.aws_db_event_subscription.fail_missing_maintenance_category... pass
      # resource.aws_db_event_subscription.fail_missing_both_categories... running
      # resource.aws_db_event_subscription.fail_missing_both_categories... pass
      # resource.aws_db_event_subscription.fail_disabled_subscription... running
      # resource.aws_db_event_subscription.fail_disabled_subscription... pass
      # resource.aws_db_event_subscription.pass_db_instance_filtered_out... running
      # resource.aws_db_event_subscription.pass_db_instance_filtered_out... pass
      # resource.aws_db_event_subscription.pass_no_subscriptions... running
      # resource.aws_db_event_subscription.pass_no_subscriptions... pass
      # resource.aws_db_event_subscription.pass_db_instance_filtered_out... running
      # resource.aws_db_event_subscription.pass_db_instance_filtered_out... pass
      # rds-cluster-event-notifications-configured.policytest.hcl... pass
```

---
