# Aurora MySQL DB clusters should publish audit logs to CloudWatch Logs

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an Amazon Aurora MySQL DB cluster is configured to publish audit logs to Amazon CloudWatch Logs. The control fails if the cluster isn't configured to publish audit logs to CloudWatch Logs. The control doesn't generate findings for Aurora Serverless v1 DB clusters.

Audit logs capture a record of database activity, including login attempts, data modifications, schema changes, and other events that can be audited for security and compliance purposes. When you configure an Aurora MySQL DB cluster to publish audit logs to a log group in Amazon CloudWatch Logs, you can perform real-time analysis of the log data. CloudWatch Logs retains logs in highly durable storage. You can also create alarms and view metrics in CloudWatch.

An alternative way to publish audit logs to CloudWatch Logs is by enabling advanced auditing and setting the cluster-level DB parameter server_audit_logs_upload to 1. The default for the server_audit_logs_upload parameter is 0. However, we recommend you use the following remediation instructions instead to pass this control.

This rule is covered by the [rds-aurora-mysql-audit-logging-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/rds/rds-aurora-mysql-audit-logging-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # rds-aurora-mysql-audit-logging-enabled.policytest.hcl... running
      # resource.aws_rds_cluster.pass_audit_logging_enabled... running
      # resource.aws_rds_cluster.pass_audit_logging_enabled... pass
      # resource.aws_rds_cluster.fail_audit_logging_disabled... running
      # resource.aws_rds_cluster.fail_audit_logging_disabled... pass
      # resource.aws_rds_cluster.skip_aurora_postgresql... running
      # resource.aws_rds_cluster.skip_aurora_postgresql... pass
      # resource.aws_rds_cluster.fail_audit_logging_disabled... running
      # resource.aws_rds_cluster.fail_audit_logging_disabled... pass
      # resource.aws_rds_cluster.pass_audit_logging_enabled... running
      # resource.aws_rds_cluster.pass_audit_logging_enabled... pass
      # resource.aws_rds_cluster.pass_multiple_log_types... running
      # resource.aws_rds_cluster.pass_multiple_log_types... pass
      # rds-aurora-mysql-audit-logging-enabled.policytest.hcl... pass
```

---
