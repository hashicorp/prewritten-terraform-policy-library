# S3 general purpose buckets should have event notifications enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

Parameters:

| Parameter | Description | Type | Allowed custom values | Security Hub CSPM default value |
| --------- | ----------- | ---- | --------------------- | -------------------------------- |
| eventTypes | List of preferred S3 event types | EnumList (maximum of 28 items) | s3:IntelligentTiering, s3:LifecycleExpiration:*, s3:LifecycleExpiration:Delete, s3:LifecycleExpiration:DeleteMarkerCreated, s3:LifecycleTransition, s3:ObjectAcl:Put, s3:ObjectCreated:*, s3:ObjectCreated:CompleteMultipartUpload, s3:ObjectCreated:Copy, s3:ObjectCreated:Post, s3:ObjectCreated:Put, s3:ObjectRemoved:*, s3:ObjectRemoved:Delete, s3:ObjectRemoved:DeleteMarkerCreated, s3:ObjectRestore:*, s3:ObjectRestore:Completed, s3:ObjectRestore:Delete, s3:ObjectRestore:Post, s3:ObjectTagging:*, s3:ObjectTagging:Delete, s3:ObjectTagging:Put, s3:ReducedRedundancyLostObject, s3:Replication:*, s3:Replication:OperationFailedReplication, s3:Replication:OperationMissedThreshold, s3:Replication:OperationNotTracked, s3:Replication:OperationReplicatedAfterThreshold, s3:TestEvent | No default value |

This control checks whether S3 Event Notifications are enabled on an Amazon S3 general purpose bucket. The control fails if S3 Event Notifications are not enabled on the bucket. If you provide custom values for the eventTypes parameter, the control passes only if event notifications are enabled for the specified types of events.

When you enable S3 Event Notifications, you receive alerts when specific events occur that impact your S3 buckets. For example, you can be notified of object creation, object removal, and object restoration. These notifications can alert relevant teams to accidental or intentional modifications that may lead to unauthorized data access.

This rule is covered by the [s3-bucket-should-have-event-notifications-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/s3/s3-bucket-should-have-event-notifications-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # s3-bucket-should-have-event-notifications-enabled.policytest.hcl... running
      # resource.aws_s3_bucket.pass_with_topic_notification... running
      # resource.aws_s3_bucket.pass_with_topic_notification... pass
      # resource.aws_s3_bucket.fail_no_notification... running
      # resource.aws_s3_bucket.fail_no_notification... pass
      # resource.aws_s3_bucket.fail_queue_only... running
      # resource.aws_s3_bucket.fail_queue_only... pass
      # resource.aws_s3_bucket.fail_empty_topic... running
      # resource.aws_s3_bucket.fail_empty_topic... pass
      # resource.aws_s3_bucket.fail_null_topic... running
      # resource.aws_s3_bucket.fail_null_topic... pass
      # resource.aws_s3_bucket.fail_other_bucket_notification... running
      # resource.aws_s3_bucket.fail_other_bucket_notification... pass
      # s3-bucket-should-have-event-notifications-enabled.policytest.hcl... pass
```

---