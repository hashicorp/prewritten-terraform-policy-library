# Copyright IBM Corp. 2026

# CloudFront distributions should not point to non-existent S3 origins

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "cloudfront-s3-origin-non-existent-bucket-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_cloudfront_distribution" "no_nonexistent_s3_origins" {
  enforcement_level = input.cloudfront-s3-origin-non-existent-bucket-enforcement-level

  locals {
    origins = core::try(attrs.origin, [])

    s3_origins = core::try([
      for origin in local.origins :
      origin if core::try(origin.custom_origin_config, null) == null
    ], [])
  }

  filter = core::length(local.s3_origins) > 0

  # The bucket name is the first label of origin.domain_name
  # (e.g. my-bucket.s3.amazonaws.com → "my-bucket").
  # Each S3 origin must match an aws_s3_bucket whose bucket attribute equals
  # that extracted name.
  connected "aws_s3_bucket" {
    each "s3_origins" {
      connection {
        subject = "domain_name"
        target  = "bucket_regional_domain_name"
      }
    }

    cardinality = {
      min_matches = 1
      error_message = "CloudFront distribution points to a non-existent S3 origin. All S3 origins must reference buckets defined in the Terraform configuration to prevent malicious third parties from creating the bucket and serving unauthorized content"
    }
  }
}
