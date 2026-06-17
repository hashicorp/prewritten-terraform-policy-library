# CloudFront.1 - CloudFront distributions should have a default root object configured.

policy {}

input "cloudfront-default-root-object-configured-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_cloudfront_distribution" "default-root-object-configured" {
    enforcement_level = input.cloudfront-default-root-object-configured-enforcement-level
    locals {
        origins = core::try(attrs.origin, [])
        s3_origins = [
            for origin in local.origins : origin
            if core::try(origin.origin_access_control_id, "") != "" || core::try(origin.s3_origin_config, null) != null
        ]
        condition = core::length(local.s3_origins) > 0 ? core::try(attrs.default_root_object, "") != "" : true
    }

    enforce {
        condition = local.condition
        error_message = "CloudFront distribution does not have a default root object configured. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/cloudfront-controls.html#cloudfront-1 for more details."
    }
}
