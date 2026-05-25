# Policy: S3.12 - ACLs should not be used to manage user access to S3 general purpose buckets

policy {}

locals {
  # Fetch all aws_s3_bucket_acl resources in the plan
  all_bucket_acls = core::getresources("aws_s3_bucket_acl", {})

  # Build a set of bucket names that have an associated aws_s3_bucket_acl
  # which configures user access (either via canned 'acl' or 'access_control_policy').
  buckets_with_acl_access = {
    for acl in local.all_bucket_acls :
    core::try(acl.bucket, "") => true
    if(
      core::try(acl.acl, "") != "" ||
      core::length(core::try(acl.access_control_policy, [])) > 0
    )
  }
}

resource_policy "aws_s3_bucket" "acl_prohibited" {
  locals {
    bucket_name = core::try(attrs.bucket, "")

    # An S3 bucket is non-compliant if it has an associated aws_s3_bucket_acl
    # resource that grants user access via ACL configuration.
    has_acl_association = core::try(local.buckets_with_acl_access[local.bucket_name], false)
  }

  enforce {
    condition     = !local.has_acl_association
    error_message = "S3 bucket must not be managed by an aws_s3_bucket_acl resource. Remove the associated aws_s3_bucket_acl (its 'acl' / 'access_control_policy' configuration) and use a bucket policy or IAM policy instead. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-12 for more details."
  }
}
