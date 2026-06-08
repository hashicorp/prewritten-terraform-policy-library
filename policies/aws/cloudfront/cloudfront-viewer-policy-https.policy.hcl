# Copyright IBM Corp. 2026

# CloudFront.3 - CloudFront distributions should require encryption in transit.

policy {}

resource_policy "aws_cloudfront_distribution" "viewer-policy-https" {
    locals {
        default_cache_behavior = core::try(attrs.default_cache_behavior[0].viewer_protocol_policy, "") != "allow-all"
        ordered_cache_behavior = core::try(attrs.ordered_cache_behavior[0].viewer_protocol_policy, "") != "allow-all"
    }
    enforce {
        condition = local.default_cache_behavior && local.ordered_cache_behavior
        error_message = "CloudFront distribution viewer_protocol_policy is set to 'allow-all'. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/cloudfront-controls.html#cloudfront-3 for more details."
    }
}
