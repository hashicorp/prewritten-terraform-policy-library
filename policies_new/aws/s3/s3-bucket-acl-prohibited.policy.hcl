# Copyright IBM Corp. 2026

# ACLs should not be used to manage user access to S3 general purpose buckets

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "s3-bucket-acl-prohibited-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_s3_bucket" "acl_prohibited" {
  enforcement_level = input.s3-bucket-acl-prohibited-enforcement-level

  connected "aws_s3_bucket_acl" {
    connection {
      subject = "bucket"
      target  = "bucket"
    }

    enforce {
      condition     = core::try(self.acl, "") == "" && core::length(core::try(self.access_control_policy, [])) == 0
      error_message = "S3 bucket must not be managed by an aws_s3_bucket_acl resource. Remove the associated aws_s3_bucket_acl (its 'acl' / 'access_control_policy' configuration) and use a bucket policy or IAM policy instead"
    }
  }
}
