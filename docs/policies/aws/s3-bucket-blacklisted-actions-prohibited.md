# S3 general purpose bucket policies should restrict access to other AWS accounts

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Sensitive API operations actions restricted |

## Description

This control checks whether an Amazon S3 general purpose bucket policy prevents principals from other AWS accounts from performing denied actions on resources in the S3 bucket. The control fails if the bucket policy allows one or more of the preceding actions for a principal in another AWS account.

Implementing least privilege access is fundamental to reducing security risk and the impact of errors or malicious intent. If an S3 bucket policy allows access from external accounts, it could result in data exfiltration by an insider threat or an attacker.

The blacklistedactionpatterns parameter allows for successful evaluation of the rule for S3 buckets. The parameter grants access to external accounts for action patterns that are not included in the blacklistedactionpatterns list.

This rule is covered by the [s3-bucket-blacklisted-actions-prohibited](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/s3/s3-bucket-blacklisted-actions-prohibited.policy.hcl) policy.

## Policy Results

```bash
trace:
      # s3-bucket-blacklisted-actions-prohibited.policytest.hcl... running
      # resource.aws_s3_bucket_policy.pass_service_principal... running
      # resource.aws_s3_bucket_policy.pass_service_principal... pass
      # resource.aws_s3_bucket_policy.pass_safe_actions_external... running
      # resource.aws_s3_bucket_policy.pass_safe_actions_external... pass
      # resource.aws_s3_bucket_policy.pass_empty_policy... running
      # resource.aws_s3_bucket_policy.pass_empty_policy... pass
      # resource.aws_s3_bucket_policy.fail_wildcard_principal... running
      # resource.aws_s3_bucket_policy.fail_wildcard_principal... pass
      # resource.aws_s3_bucket_policy.fail_external_delete_policy... running
      # resource.aws_s3_bucket_policy.fail_external_delete_policy... pass
      # resource.aws_s3_bucket_policy.fail_external_put_acl... running
      # resource.aws_s3_bucket_policy.fail_external_put_acl... pass
      # resource.aws_s3_bucket_policy.fail_external_put_encryption... running
      # resource.aws_s3_bucket_policy.fail_external_put_encryption... pass
      # resource.aws_s3_bucket_policy.fail_multiple_blacklisted... running
      # resource.aws_s3_bucket_policy.fail_multiple_blacklisted... pass
      # resource.aws_s3_bucket_policy.fail_wildcard_aws_principal... running
      # resource.aws_s3_bucket_policy.fail_wildcard_aws_principal... pass
      # resource.aws_s3_bucket_policy.pass_deny_statement... running
      # resource.aws_s3_bucket_policy.pass_deny_statement... pass
      # s3-bucket-blacklisted-actions-prohibited.policytest.hcl... pass
```

---
