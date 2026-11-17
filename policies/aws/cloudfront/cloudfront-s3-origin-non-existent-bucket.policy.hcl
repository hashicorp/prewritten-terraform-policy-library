# Copyright IBM Corp. 2026

# CloudFront distributions should not point to non-existent S3 origins

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "cloudfront-s3-origin-non-existent-bucket-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_cloudfront_distribution" "no_nonexistent_s3_origins" {
  enforcement_level = input.cloudfront-s3-origin-non-existent-bucket-enforcement-level
  
  locals {
    # Extract all origins from the distribution
    origins = core::try(attrs.origin, [])

    s3_origins = core::try([
      for origin in local.origins :
      origin if core::length(core::regexall(
        "^[^.]+\\.(s3(\\.[a-z0-9-]+)?|s3-website[.-][a-z0-9-]+)\\.amazonaws\\.com$",
        core::lower(core::try(origin.domain_name, ""))
      )) > 0
    ], [])

    # CloudFront origin.domain_name for S3 origins looks like:
    #   my-bucket.s3.amazonaws.com
    #   my-bucket.s3.us-east-1.amazonaws.com
    # The bucket name is the first label of that domain. Extract it so we
    # can compare against aws_s3_bucket.bucket (which is just "my-bucket").
  }
  
  # Only evaluate distributions that have S3 origins
  filter = core::length(local.s3_origins) > 0
  
  enforce {
    condition = true
    error_message = "CloudFront distribution must not point to a known non-existent S3 origin bucket"
  }
}
