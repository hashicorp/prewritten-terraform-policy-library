# Copyright IBM Corp. 2026

# CloudFront distributions should use origin access control

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.29.0, < 7.0.0"
    }
  }
}

input "cloudfront-s3-origin-access-control-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

# NOTE: The original policy fetches all_oac_resources and all_bucket_policies via
# getresources but uses neither in any enforce condition — they were cached but
# never referenced. They are dropped here.

resource_policy "aws_cloudfront_distribution" "oac_required" {
  enforcement_level = input.cloudfront-s3-origin-access-control-enabled-enforcement-level

  locals {
    origins     = core::try(attrs.origin, [])
    has_origins = core::try(core::length(local.origins) > 0, false)

    likely_s3_origins = core::try([
      for origin in local.origins :
      origin if core::try(origin.custom_origin_config, null) == null
    ], [])

    has_likely_s3_origins = core::length(local.likely_s3_origins) > 0

    s3_origins_without_oac = [
      for origin in local.likely_s3_origins :
      origin if core::try(origin.origin_access_control_id, null) == null || core::try(origin.origin_access_control_id, "") == ""
    ]

    all_s3_origins_have_oac = local.has_likely_s3_origins && core::length(local.s3_origins_without_oac) == 0

    missing_oac_origin_ids = [
      for origin in local.s3_origins_without_oac :
      core::try(origin.origin_id, "unknown")
    ]
  }

  enforce {
    condition     = local.has_origins
    error_message = "CloudFront distribution has no origins configured (origin is null or empty). At least one origin must be defined"
  }

  enforce {
    condition     = !local.has_likely_s3_origins || local.all_s3_origins_have_oac
    error_message = "CloudFront distribution has origins without origin access control (OAC). Origins missing OAC: ${core::join(", ", local.missing_oac_origin_ids)}. Configure origin_access_control_id for all S3 origins to restrict access through CloudFront only"
  }
}

resource_policy "aws_cloudfront_origin_access_control" "proper_configuration" {
  enforcement_level = input.cloudfront-s3-origin-access-control-enabled-enforcement-level
  filter = core::try(attrs.origin_access_control_origin_type, "") == "s3"

  locals {
    signing_behavior          = core::try(attrs.signing_behavior, null) != null ? attrs.signing_behavior : ""
    has_valid_signing_behavior = local.signing_behavior == "always"

    signing_protocol          = core::try(attrs.signing_protocol, null) != null ? attrs.signing_protocol : ""
    has_valid_signing_protocol = local.signing_protocol == "sigv4"
  }

  enforce {
    condition     = local.has_valid_signing_behavior
    error_message = "Origin Access Control must have signing_behavior set to 'always' (current: '${local.signing_behavior}'). This ensures CloudFront always signs requests to the S3 origin"
  }

  enforce {
    condition     = local.has_valid_signing_protocol
    error_message = "Origin Access Control must have signing_protocol set to 'sigv4' (current: '${local.signing_protocol}'). SigV4 is required for secure authentication with S3"
  }
}
