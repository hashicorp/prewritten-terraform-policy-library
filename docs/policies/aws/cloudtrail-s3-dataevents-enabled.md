# At least one CloudTrail trail should log Amazon S3 data events

| Provider | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This policy checks if at least one AWS CloudTrail trail is logging Amazon Simple Storage Service (Amazon S3) data events for all S3 buckets. The policy fails if there are trails or if no trails record S3 data events.

The policy evaluates `aws_cloudtrail` resources.

For advanced event selectors, a `resources.ARN` `starts_with` filter counts only when it covers every required bucket (or all buckets). `ends_with`, `not_starts_with` and `not_ends_with` filters on `resources.ARN` narrow coverage in ways a plan cannot resolve, so selectors that use them do not count.

This rule is covered by the [cloudtrail-s3-dataevents-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudtrail/cloudtrail-s3-dataevents-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloudtrail-s3-dataevents-enabled.policytest.hcl...
      running
      #
      resource.aws_cloudtrail.pass_legacy_target_bucket_matched...
      running
      #
      resource.aws_cloudtrail.pass_legacy_target_bucket_matched...
      pass
      #
      resource.aws_cloudtrail.pass_legacy_all_pattern_covers_target...
      running
      #
      resource.aws_cloudtrail.pass_legacy_all_pattern_covers_target...
      pass
      # resource.aws_cloudtrail.pass_legacy_all_buckets_f11...
      running
      # resource.aws_cloudtrail.pass_legacy_all_buckets_f11...
      pass
      # resource.aws_cloudtrail.pass_advanced_all_buckets_f11...
      running
      # resource.aws_cloudtrail.pass_advanced_all_buckets_f11...
      pass
      # resource.aws_cloudtrail.pass_legacy_empty_values_f11...
      running
      # resource.aws_cloudtrail.pass_legacy_empty_values_f11...
      pass
      #
      resource.aws_cloudtrail.pass_enable_logging_omitted_f11...
      running
      #
      resource.aws_cloudtrail.pass_enable_logging_omitted_f11...
      pass
      # resource.aws_cloudtrail.pass_enable_logging_null_f11...
      running
      # resource.aws_cloudtrail.pass_enable_logging_null_f11...
      pass
      #
      resource.aws_cloudtrail.pass_management_only_trail_alongside_compliant_f11...
      running
      #
      resource.aws_cloudtrail.pass_management_only_trail_alongside_compliant_f11...
      pass
      #
      resource.aws_cloudtrail.pass_starts_with_target_bucket_f13...
      running
      #
      resource.aws_cloudtrail.pass_starts_with_target_bucket_f13...
      pass
      # cloudtrail-s3-dataevents-enabled.policytest.hcl...
      pass
```

---
