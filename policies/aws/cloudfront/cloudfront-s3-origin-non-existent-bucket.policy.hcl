# Policy - CloudFront.12: CloudFront distributions should not point to non-existent S3 origins

policy {}

input "cloudfront-s3-origin-non-existent-bucket-enforcement-level" {
  type = string
  default = "advisory"
}

# Cache all S3 buckets once for performance
locals {
  all_s3_buckets = core::getresources("aws_s3_bucket", {})
  
  # Extract bucket names for lookup
  bucket_names = [for bucket in local.all_s3_buckets : bucket.bucket]
}

resource_policy "aws_cloudfront_distribution" "no_nonexistent_s3_origins" {
  enforcement_level = input.cloudfront-s3-origin-non-existent-bucket-enforcement-level
  
  locals {
    # Extract all origins from the distribution
    origins = core::try(attrs.origin, [])

    # Filter to S3 origins only (those with s3_origin_config block).
    # Per AWS Config rule CLOUDFRONT_S3_ORIGIN_NON_EXISTENT_BUCKET, only
    # origins using S3OriginConfig are evaluated (S3 buckets with static
    # website hosting are skipped because they use custom_origin_config).
    s3_origins = [
      for origin in local.origins :
      origin if core::try(core::length(origin.s3_origin_config), 0) > 0
    ]

    # CloudFront origin.domain_name for S3 origins looks like:
    #   my-bucket.s3.amazonaws.com
    #   my-bucket.s3.us-east-1.amazonaws.com
    # The bucket name is the first label of that domain. Extract it so we
    # can compare against aws_s3_bucket.bucket (which is just "my-bucket").
    invalid_origin_buckets = [
      for origin in local.s3_origins :
      core::try(core::split(".", core::try(origin.domain_name, ""))[0], "")
      if !core::contains(
        local.bucket_names,
        core::try(core::split(".", core::try(origin.domain_name, ""))[0], "")
      )
    ]

    # Check if all S3 origins resolve to a known bucket
    all_origins_valid = core::length(local.invalid_origin_buckets) == 0
  }
  
  # Only evaluate distributions that have S3 origins
  filter = core::length(local.s3_origins) > 0
  
  enforce {
    condition = local.all_origins_valid
    error_message = "CloudFront distribution points to non-existent S3 origin bucket(s): ${core::join(", ", local.invalid_origin_buckets)}. All S3 origins must reference buckets defined in the Terraform configuration to prevent malicious third parties from creating the bucket and serving unauthorized content. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/cloudfront-controls.html#cloudfront-12 for more details."
  }
}
