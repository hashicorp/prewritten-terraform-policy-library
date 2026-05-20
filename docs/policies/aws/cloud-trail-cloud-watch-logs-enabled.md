# CloudTrail trails should be integrated with Amazon CloudWatch Logs

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether CloudTrail trails are configured to send logs to CloudWatch Logs. The control fails if the CloudWatchLogsLogGroupArn property of the trail is empty.

CloudTrail records AWS API calls that are made in a given account. The recorded information includes the following:

CloudTrail uses Amazon S3 for log file storage and delivery. You can capture CloudTrail logs in a specified S3 bucket for long-term analysis. To perform real-time analysis, you can configure CloudTrail to send logs to CloudWatch Logs.

For a trail that is enabled in all Regions in an account, CloudTrail sends log files from all of those Regions to a CloudWatch Logs log group.

Security Hub CSPM recommends that you send CloudTrail logs to CloudWatch Logs. Note that this recommendation is intended to ensure that account activity is captured, monitored, and appropriately alarmed on. You can use CloudWatch Logs to set this up with your AWS services. This recommendation does not preclude the use of a different solution.

Sending CloudTrail logs to CloudWatch Logs facilitates real-time and historic activity logging based on user, API, resource, and IP address. You can use this approach to establish alarms and notifications for anomalous or sensitivity account activity.

This rule is covered by the [cloud-trail-cloud-watch-logs-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/cloudtrail/cloud-trail-cloud-watch-logs-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloud-trail-cloud-watch-logs-enabled.policytest.hcl... running
      # resource.aws_cloudtrail.pass_cloudwatch_logs_enabled... running
      # resource.aws_cloudtrail.pass_cloudwatch_logs_enabled... pass
      # resource.aws_cloudtrail.fail_cloudwatch_logs_missing... running
      # resource.aws_cloudtrail.fail_cloudwatch_logs_missing... pass
      # resource.aws_cloudtrail.fail_cloudwatch_logs_empty... running
      # resource.aws_cloudtrail.fail_cloudwatch_logs_empty... pass
      # cloud-trail-cloud-watch-logs-enabled.policytest.hcl... pass
```

---
