# OpenSearch domain error logging to CloudWatch Logs should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether OpenSearch domains are configured to send error logs to CloudWatch Logs. This control fails if error logging to CloudWatch is not enabled for a domain.

You should enable error logs for OpenSearch domains and send those logs to CloudWatch Logs for retention and response. Domain error logs can assist with security and access audits, and can help to diagnose availability issues.

This rule is covered by the [opensearch-logs-to-cloudwatch](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/opensearch/opensearch-logs-to-cloudwatch.policy.hcl) policy.

## Policy Results

```bash
trace:
      # opensearch-logs-to-cloudwatch.policytest.hcl... running
      # resource.aws_opensearch_domain.pass_explicit_enabled... running
      # resource.aws_opensearch_domain.pass_explicit_enabled... pass
      # resource.aws_opensearch_domain.pass_enabled_omitted... running
      # resource.aws_opensearch_domain.pass_enabled_omitted... pass
      # resource.aws_opensearch_domain.pass_multiple_log_types... running
      # resource.aws_opensearch_domain.pass_multiple_log_types... pass
      # resource.aws_opensearch_domain.fail_empty_logging... running
      # resource.aws_opensearch_domain.fail_empty_logging... pass
      # resource.aws_opensearch_domain.fail_no_application_logs... running
      # resource.aws_opensearch_domain.fail_no_application_logs... pass
      # resource.aws_opensearch_domain.fail_explicitly_disabled... running
      # resource.aws_opensearch_domain.fail_explicitly_disabled... pass
      # resource.aws_opensearch_domain.fail_missing_log_group_arn... running
      # resource.aws_opensearch_domain.fail_missing_log_group_arn... pass
      # resource.aws_opensearch_domain.fail_no_log_options... running
      # resource.aws_opensearch_domain.fail_no_log_options... pass
      # opensearch-logs-to-cloudwatch.policytest.hcl... pass
```

---
