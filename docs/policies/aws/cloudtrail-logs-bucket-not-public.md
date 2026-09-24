# Ensure the S3 bucket used to store CloudTrail logs is not publicly accessible

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources not publicly accessible |

## Description

This control checks whether the S3 bucket used to store CloudTrail logs is publicly accessible.

CloudTrail logs record who did what in an account, including principal names, source IP addresses, and the parameters of API calls. Exposing that bucket publicly hands an attacker a detailed map of the environment and of the identities operating in it.

The policy requires all four S3 Block Public Access settings — `block_public_acls`, `block_public_policy`, `ignore_public_acls`, and `restrict_public_buckets` — to be enabled on the trail bucket, and additionally rejects bucket ACLs and bucket policies that grant read access to `AllUsers` or `AuthenticatedUsers`.

This rule is covered by the [cloudtrail-logs-bucket-not-public](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudtrail/cloudtrail-logs-bucket-not-public.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cloudtrail-logs-bucket-not-public.policytest.hcl... running
      # resource.aws_cloudtrail.pass_all_public_access_block_settings... running
      # resource.aws_cloudtrail.pass_all_public_access_block_settings... pass
      # resource.aws_cloudtrail.pass_public_policy_shielded_by_pab... running
      # resource.aws_cloudtrail.pass_public_policy_shielded_by_pab... pass
      # resource.aws_cloudtrail.pass_public_acl_shielded_by_pab... running
      # resource.aws_cloudtrail.pass_public_acl_shielded_by_pab... pass
      # resource.aws_cloudtrail.fail_private_acl_no_pab... running
      # resource.aws_cloudtrail.fail_private_acl_no_pab... pass
      # resource.aws_cloudtrail.fail_private_inline_acl_no_pab... running
      # resource.aws_cloudtrail.fail_private_inline_acl_no_pab... pass
      # resource.aws_cloudtrail.pass_non_public_bucket_policy... running
      # resource.aws_cloudtrail.pass_non_public_bucket_policy... pass
      # resource.aws_cloudtrail.pass_empty_bucket_name... running
      # resource.aws_cloudtrail.pass_empty_bucket_name... pass
      # resource.aws_cloudtrail.pass_null_bucket_name... running
      # resource.aws_cloudtrail.pass_null_bucket_name... pass
      # resource.aws_cloudtrail.fail_missing_block_public_policy... running
      # resource.aws_cloudtrail.fail_missing_block_public_policy... pass
      # resource.aws_cloudtrail.fail_public_bucket_policy_wildcard_principal... running
      # resource.aws_cloudtrail.fail_public_bucket_policy_wildcard_principal... pass
      # resource.aws_cloudtrail.fail_public_bucket_policy_aws_star... running
      # resource.aws_cloudtrail.fail_public_bucket_policy_aws_star... pass
      # resource.aws_cloudtrail.fail_public_read_canned_acl... running
      # resource.aws_cloudtrail.fail_public_read_canned_acl... pass
      # resource.aws_cloudtrail.fail_public_read_write_canned_acl... running
      # resource.aws_cloudtrail.fail_public_read_write_canned_acl... pass
      # resource.aws_cloudtrail.fail_public_grant_acl... running
      # resource.aws_cloudtrail.fail_public_grant_acl... pass
      # resource.aws_cloudtrail.fail_inline_public_acl... running
      # resource.aws_cloudtrail.fail_inline_public_acl... pass
      # resource.aws_cloudtrail.fail_no_companion_resources... running
      # resource.aws_cloudtrail.fail_no_companion_resources... pass
      # cloudtrail-logs-bucket-not-public.policytest.hcl... pass
```

---
