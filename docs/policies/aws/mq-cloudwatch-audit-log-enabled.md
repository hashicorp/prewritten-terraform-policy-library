# ActiveMQ brokers should stream audit logs to CloudWatch

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an Amazon MQ ActiveMQ broker streams audit logs to Amazon CloudWatch Logs. The control fails if the broker doesn't stream audit logs to CloudWatch Logs.

By publishing ActiveMQ broker logs to CloudWatch Logs, you can create CloudWatch alarms and metrics that increase the visibility of security-related information.

This rule is covered by the [mq-cloudwatch-audit-log-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/mq/mq-cloudwatch-audit-log-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # mq-cloudwatch-audit-log-enabled.policytest.hcl...
      running
      # resource.aws_mq_broker.pass_audit_enabled...
      running
      # resource.aws_mq_broker.pass_audit_enabled...
      pass
      # resource.aws_mq_broker.fail_audit_disabled...
      running
      # resource.aws_mq_broker.fail_audit_disabled...
      pass
      # resource.aws_mq_broker.fail_no_logs_config...
      running
      # resource.aws_mq_broker.fail_no_logs_config...
      pass
      # resource.aws_mq_broker.fail_audit_not_specified...
      running
      # resource.aws_mq_broker.fail_audit_not_specified...
      pass
      # resource.aws_mq_broker.skip_rabbitmq_broker...
      running
      # resource.aws_mq_broker.skip_rabbitmq_broker...
      pass
      # mq-cloudwatch-audit-log-enabled.policytest.hcl...
      pass
```

---
