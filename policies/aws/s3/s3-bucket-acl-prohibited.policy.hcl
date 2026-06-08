# Copyright IBM Corp. 2026

# Policy: S3.12 - ACLs should not be used to manage user access to S3 general purpose buckets

policy {}

resource_policy "aws_s3_bucket" "acl_prohibited" {
  locals {
    bucket_name = core::try(attrs.bucket, "")

    # Find aws_s3_bucket_acl resources targeting this bucket.
    matching_bucket_acls = core::getresources("aws_s3_bucket_acl", {
      bucket = local.bucket_name
    })

    # Determine if any of those ACLs configure user access via canned ACL
    # or access_control_policy grants.
    prohibited_acl_configs = [
      for acl in local.matching_bucket_acls :
      acl if(
        core::try(acl.acl, "") != "" ||
        core::length(core::try(acl.access_control_policy, [])) > 0
      )
    ]

    has_acl_association = core::length(local.prohibited_acl_configs) > 0
  }

  enforce {
    condition     = !local.has_acl_association
    error_message = "S3 bucket must not be managed by an aws_s3_bucket_acl resource. Remove the associated aws_s3_bucket_acl (its 'acl' / 'access_control_policy' configuration) and use a bucket policy or IAM policy instead. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-12 for more details."
  }
}
