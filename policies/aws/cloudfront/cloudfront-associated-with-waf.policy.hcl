# Policy: CloudFront.6 - CloudFront distributions should have WAF enabled

policy {}

input "cloudfront-associated-with-waf-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_cloudfront_distribution" "waf_enabled" {
    enforcement_level = input.cloudfront-associated-with-waf-enforcement-level
    locals {
        # Safely extract web_acl_id attribute
        web_acl_id = core::try(attrs.web_acl_id, "")
        
        # Check if web_acl_id is configured and not empty
        has_waf = local.web_acl_id != ""
    }

    enforce {
        condition = local.has_waf
        error_message = "CloudFront distribution must be associated with an AWS WAF web ACL. Configure the 'web_acl_id' argument with either a WAFv2 ACL ARN (e.g., aws_wafv2_web_acl.example.arn) or a WAF Classic ACL ID (e.g., aws_waf_web_acl.example.id). Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/cloudfront-controls.html#cloudfront-6 for more details."
    }
}
