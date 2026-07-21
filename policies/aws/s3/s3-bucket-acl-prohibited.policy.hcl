# Copyright IBM Corp. 2026

# Policy: S3.12 - ACLs should not be used to manage user access to S3 general purpose buckets

policy {}

input "s3-bucket-acl-prohibited-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_s3_bucket" "acl_prohibited" {
  enforcement_level = input.s3-bucket-acl-prohibited-enforcement-level
  connected "aws_s3_bucket_acl" {
    connection {
      subject   = "bucket"
      connected = "bucket"
    }

    enforce {
      condition = (
        core::try(connected.aws_s3_bucket_acl.acl, "") == "" &&
        core::length(core::try(connected.aws_s3_bucket_acl.access_control_policy, [])) == 0
      )
      error_message = "S3 bucket must not be managed by an aws_s3_bucket_acl resource. Remove the associated aws_s3_bucket_acl (its 'acl' / 'access_control_policy' configuration) and use a bucket policy or IAM policy instead. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-12 for more details."
    }
  }
}
