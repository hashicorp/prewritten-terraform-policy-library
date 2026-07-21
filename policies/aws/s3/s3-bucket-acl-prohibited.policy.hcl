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
    max_instances = 0

    connection {
      subject   = "bucket"
      connected = "bucket"
    }

    filter = (
      core::try(connected.aws_s3_bucket_acl.acl, "") != "" ||
      core::length(core::try(connected.aws_s3_bucket_acl.access_control_policy, [])) > 0
    )
  }
}
