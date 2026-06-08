# Copyright IBM Corp. 2026

# CloudFront.13 - CloudFront distributions should use origin access control

policy {}

# Cache all OAC resources for efficient lookup
locals {
    all_oac_resources = core::getresources("aws_cloudfront_origin_access_control", {})
    all_bucket_policies = core::getresources("aws_s3_bucket_policy", {})
}

resource_policy "aws_cloudfront_distribution" "oac_required" {
    # Only evaluate distributions that have at least one origin
    filter = attrs.origin != null && core::length(attrs.origin) > 0

    locals {
        # Identify likely S3 origins: origins that do NOT have custom_origin_config
        # This is a heuristic since we cannot use string matching on domain_name
        likely_s3_origins = [
            for origin in attrs.origin :
            origin if core::try(origin.custom_origin_config, null) == null
        ]

        # Check if there are any likely S3 origins
        has_likely_s3_origins = core::length(local.likely_s3_origins) > 0

        # S3 origins with OAC configured
        s3_origins_with_oac = [
            for origin in local.likely_s3_origins :
            origin if core::try(origin.origin_access_control_id, "") != ""
        ]

        # S3 origins without OAC
        s3_origins_without_oac = [
            for origin in local.likely_s3_origins :
            origin if core::try(origin.origin_access_control_id, "") == ""
        ]

        # Check if all S3 origins have OAC
        all_s3_origins_have_oac = local.has_likely_s3_origins && core::length(local.s3_origins_with_oac) == core::length(local.likely_s3_origins)

        # Create list of origin IDs missing OAC for error message
        missing_oac_origin_ids = [
            for origin in local.s3_origins_without_oac :
            core::try(origin.origin_id, "unknown")
        ]
    }

    # Enforce: Origins without custom_origin_config (likely S3) must have OAC configured
    enforce {
        condition = !local.has_likely_s3_origins || local.all_s3_origins_have_oac
        error_message = "CloudFront distribution has origins without origin access control (OAC). Origins missing OAC: ${core::join(", ", local.missing_oac_origin_ids)}. Configure origin_access_control_id for all S3 origins to restrict access through CloudFront only.Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/cloudfront-controls.html#cloudfront-13 for more details."
    
    }
}

resource_policy "aws_cloudfront_origin_access_control" "proper_configuration" {
    # Only evaluate OACs scoped to S3 origins. Other origin types (lambda,
    # mediastore, mediapackagev2) are out of scope for CloudFront.13 and are
    # covered by their own policies.
    filter = core::try(attrs.origin_access_control_origin_type, "") == "s3"

    locals {
        # Validate signing behavior
        signing_behavior = core::try(attrs.signing_behavior, "")
        has_valid_signing_behavior = local.signing_behavior == "always"

        # Validate signing protocol
        signing_protocol = core::try(attrs.signing_protocol, "")
        has_valid_signing_protocol = local.signing_protocol == "sigv4"
    }

    # Enforce: OAC must have signing_behavior set to "always"
    enforce {
        condition = local.has_valid_signing_behavior
        error_message = "Origin Access Control must have signing_behavior set to 'always' (current: '${local.signing_behavior}'). This ensures CloudFront always signs requests to the S3 origin. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/cloudfront-controls.html#cloudfront-13 for more details."
    }

    # Enforce: OAC must have signing_protocol set to "sigv4"
    enforce {
        condition = local.has_valid_signing_protocol
        error_message = "Origin Access Control must have signing_protocol set to 'sigv4' (current: '${local.signing_protocol}'). SigV4 is required for secure authentication with S3. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/cloudfront-controls.html#cloudfront-13 for more details."
    }
}

