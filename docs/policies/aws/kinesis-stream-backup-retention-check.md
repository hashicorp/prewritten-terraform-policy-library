# Kinesis streams should have an adequate data retention period

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Backup and recovery |

## Description

Parameters:

| Parameter | Description | Type | Allowed custom values | Security Hub CSPM default value |
| --------- | ----------- | ---- | --------------------- | -------------------------------- |
| minimumBackupRetentionPeriod | Minimum number of hours that the data should be retained. | String | 24 to 8760 | 168 |

This control checks whether an Amazon Kinesis data stream has a data retention period greater than or equal to the specified time frame. The control fails if the data retention period is less than the specified time frame. Unless you provide a custom parameter value for the data retention period, Security Hub CSPM uses a default value of 168 hours.

In Kinesis Data Streams, a data stream is an ordered sequence of data records meant to be written to and read from in real time. Data records are stored in shards in your stream temporarily. The time period from when a record is added to when it is no longer accessible is called the retention period. Kinesis Data Streams almost immediately makes records older than the new retention period inaccessible after decreasing the retention period. For example, changing the retention period from 24 hours to 48 hours means that records added to the stream 23 hours 55 minutes prior are still available after 24 hours.

This rule is covered by the [kinesis-stream-backup-retention-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/kinesis/kinesis-stream-backup-retention-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # kinesis-stream-backup-retention-check.policytest.hcl...
      running
      # resource.aws_kinesis_stream.compliant_minimum...
      running
      # resource.aws_kinesis_stream.compliant_minimum...
      pass
      # resource.aws_kinesis_stream.compliant_high...
      running
      # resource.aws_kinesis_stream.compliant_high...
      pass
      # resource.aws_kinesis_stream.compliant_maximum...
      running
      # resource.aws_kinesis_stream.compliant_maximum...
      pass
      # resource.aws_kinesis_stream.noncompliant_default...
      running
      # resource.aws_kinesis_stream.noncompliant_default...
      pass
      # resource.aws_kinesis_stream.noncompliant_low...
      running
      # resource.aws_kinesis_stream.noncompliant_low...
      pass
      # resource.aws_kinesis_stream.noncompliant_edge...
      running
      # resource.aws_kinesis_stream.noncompliant_edge...
      pass
      # kinesis-stream-backup-retention-check.policytest.hcl...
      pass
```

---