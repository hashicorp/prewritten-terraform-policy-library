# An RDS event notifications subscription should be configured for critical database parameter group events

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Application monitoring |

## Description

This control checks whether an Amazon RDS event subscription exists with notifications enabled for the following source type, event category key-value pairs. The control passes if there are no existing event subscriptions in your account.

RDS event notifications use Amazon SNS to make you aware of changes in the availability or configuration of your RDS resources. These notifications allow for rapid response. For additional information about RDS event notifications, see Using Amazon RDS event notification in the Amazon RDS User Guide.

This rule is covered by the [rds-pg-event-notifications-configured](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-pg-event-notifications-configured.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-pg-event-notifications-configured.policytest.hcl... running
      # resource.aws_db_event_subscription.pass_all_required_categories... running
      # resource.aws_db_event_subscription.pass_all_required_categories... pass
      # resource.aws_db_event_subscription.fail_missing_maintenance... running
      # resource.aws_db_event_subscription.fail_missing_maintenance... pass
      # resource.aws_db_event_subscription.fail_missing_config_change... running
      # resource.aws_db_event_subscription.fail_missing_config_change... pass
      # resource.aws_db_event_subscription.fail_missing_failure... running
      # resource.aws_db_event_subscription.fail_missing_failure... pass
      # resource.aws_db_event_subscription.fail_no_categories... running
      # resource.aws_db_event_subscription.fail_no_categories... pass
      # resource.aws_db_event_subscription.fail_disabled_subscription... running
      # resource.aws_db_event_subscription.fail_disabled_subscription... pass
      # resource.aws_db_event_subscription.pass_unspecified_source_type... running
      # resource.aws_db_event_subscription.pass_unspecified_source_type... pass
      # resource.aws_db_event_subscription.pass_different_source_type_filtered... running
      # resource.aws_db_event_subscription.pass_different_source_type_filtered... pass
      # rds-pg-event-notifications-configured.policytest.hcl... pass
```

---
