# Redshift Serverless namespaces should export logs to CloudWatch Logs

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether an Amazon Redshift Serverless namespace is configured to export connection and user logs to Amazon CloudWatch Logs. The control fails if the Redshift Serverless namespace isn't configured to export the logs to CloudWatch Logs.

If you configure Amazon Redshift Serverless to export connection log (`connectionlog`) and user log (`userlog`) data to a log group in Amazon CloudWatch Logs, you can collect and store your log records in durable storage, which can support security, access, and availability reviews and audits. With CloudWatch Logs, you can also perform real-time analysis of log data and use CloudWatch to create alarms and review metrics.

This rule is covered by the [redshift-serverless-publish-logs-to-cloudwatch](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/redshift/redshift-serverless-publish-logs-to-cloudwatch.policy.hcl) policy.

## Policy Results

```bash
trace:
      # redshift-serverless-publish-logs-to-cloudwatch.policytest.hcl...
      running
      # resource.aws_redshiftserverless_namespace.compliant_namespace...
      running
      # resource.aws_redshiftserverless_namespace.compliant_namespace...
      pass
      # resource.aws_redshiftserverless_namespace.missing_userlog...
      running
      # resource.aws_redshiftserverless_namespace.missing_userlog...
      pass
      # resource.aws_redshiftserverless_namespace.missing_connectionlog...
      running
      # resource.aws_redshiftserverless_namespace.missing_connectionlog...
      pass
      # resource.aws_redshiftserverless_namespace.missing_all_logs...
      running
      # resource.aws_redshiftserverless_namespace.missing_all_logs...
      pass
      # redshift-serverless-publish-logs-to-cloudwatch.policytest.hcl...
      pass
```

---