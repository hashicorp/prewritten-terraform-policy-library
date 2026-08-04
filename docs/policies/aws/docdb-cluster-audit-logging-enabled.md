# Amazon DocumentDB clusters should publish audit logs to CloudWatch Logs

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an Amazon DocumentDB cluster publishes audit logs to Amazon CloudWatch Logs. The control fails if the cluster doesn't publish audit logs to CloudWatch Logs.

Amazon DocumentDB (with MongoDB compatibility) allows you to audit events that were performed in your cluster. Examples of logged events include successful and failed authentication attempts, dropping a collection in a database, or creating an index. By default, auditing is disabled in Amazon DocumentDB and requires that you take action to enable it.

This rule is covered by the [docdb-cluster-audit-logging-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/docdb/docdb-cluster-audit-logging-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # docdb-cluster-audit-logging-enabled.policytest.hcl... running
      # resource.aws_docdb_cluster.pass_audit_only... running
      # resource.aws_docdb_cluster.pass_audit_only... pass
      # resource.aws_docdb_cluster.pass_audit_and_profiler... running
      # resource.aws_docdb_cluster.pass_audit_and_profiler... pass
      # resource.aws_docdb_cluster.pass_profiler_then_audit... running
      # resource.aws_docdb_cluster.pass_profiler_then_audit... pass
      # resource.aws_docdb_cluster.fail_profiler_only... running
      # resource.aws_docdb_cluster.fail_profiler_only... pass
      # resource.aws_docdb_cluster.fail_empty_logs... running
      # resource.aws_docdb_cluster.fail_empty_logs... pass
      # resource.aws_docdb_cluster.fail_missing_logs... running
      # resource.aws_docdb_cluster.fail_missing_logs... pass
      # docdb-cluster-audit-logging-enabled.policytest.hcl... pass
```

---
