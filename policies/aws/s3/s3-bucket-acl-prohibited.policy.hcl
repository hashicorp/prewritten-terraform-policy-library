# Copyright IBM Corp. 2026

# ACLs should not be used to manage user access to S3 general purpose buckets

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "s3-bucket-acl-prohibited-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_s3_bucket" "acl_prohibited" {
  enforcement_level = input.s3-bucket-acl-prohibited-enforcement-level
  locals {
    bucket_name = core::try(attrs.bucket, "")

    # ACL set directly on the aws_s3_bucket resource. Still present in the provider
    # schema for the supported range (>= 4.0.0, < 7.0.0), so this is a live check.
    has_direct_acl = core::try(attrs.acl, "") != ""

    # Find separate aws_s3_bucket_acl resources targeting this bucket.
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
    condition     = !local.has_direct_acl && !local.has_acl_association
    error_message = "S3 bucket must not use ACLs to manage access, whether set directly on the bucket resource via 'acl' or via an associated aws_s3_bucket_acl resource. Use a bucket policy or IAM policy instead."
  }
}
