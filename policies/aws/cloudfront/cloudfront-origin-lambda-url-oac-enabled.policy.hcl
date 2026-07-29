# Copyright IBM Corp. 2026

# Policy: CloudFront.16 - CloudFront distributions should use origin access control for Lambda function URL origins

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "cloudfront-origin-lambda-url-oac-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_cloudfront_distribution" "lambda_url_oac_required" {
    enforcement_level = input.cloudfront-origin-lambda-url-oac-enabled-enforcement-level
    # Filter to only check distributions that have origins
    filter = attrs.origin != null && core::length(attrs.origin) > 0

    locals {
        # Convert the origin collection to a list for iteration.
        origins = [for origin in attrs.origin : origin]

        # Identify Lambda function URL origins by matching the Lambda URL host pattern.
        # Lambda function URLs are custom origins and use a host like:
        # <url-id>.lambda-url.<region>.on.aws
        lambda_origins = [
            for origin in local.origins :
            origin if (
                core::try(origin.custom_origin_config, null) != null &&
                core::length(core::try(origin.custom_origin_config, [])) > 0 &&
                core::length(
                    core::regexall(
                        "^[^.]+\\.lambda-url\\.[^.]+\\.on\\.aws$",
                        core::trimsuffix(
                            core::trimprefix(
                                core::trimprefix(core::try(origin.domain_name, ""), "https://"),
                                "http://"
                            ),
                            "/"
                        )
                    )
                ) > 0
            )
        ]

        # Check each Lambda origin for OAC
        lambda_origins_without_oac = [
            for origin in local.lambda_origins :
            origin if core::try(origin.origin_access_control_id, null) == null
        ]

        # Check if any Lambda origins exist
        has_lambda_origins = core::length(local.lambda_origins) > 0

        # Check if all Lambda origins have OAC
        all_lambda_origins_have_oac = core::length(local.lambda_origins_without_oac) == 0

        # Build error message with details
        missing_oac_origins = [
            for origin in local.lambda_origins_without_oac :
            core::try(origin.origin_id, "unknown")
        ]
    }

    # Only enforce if there are Lambda function URL origins
    enforce {
        condition = !local.has_lambda_origins || local.all_lambda_origins_have_oac
        error_message = <<-EOT
CloudFront distribution has Lambda function URL origins without origin access control (OAC).

Origins missing OAC: ${core::join(", ", local.missing_oac_origins)}

Lambda function URLs must use origin access control (OAC) for security:
- OAC uses IAM service principals to authenticate requests
- Prevents unauthorized direct access to Lambda function URLs
- Supports resource-based policies for fine-grained access control

Remediation:
1. Create an aws_cloudfront_origin_access_control resource with origin_access_control_origin_type = "lambda"
2. Add the OAC ID to the origin's origin_access_control_id attribute
3. Configure the Lambda function URL with authorization_type = "AWS_IAM"
4. Add a resource-based policy to the Lambda function allowing CloudFront to invoke it

Example:
  resource "aws_cloudfront_origin_access_control" "lambda_oac" {
    name                              = "lambda-oac"
    origin_access_control_origin_type = "lambda"
    signing_behavior                  = "always"
    signing_protocol                  = "sigv4"
  }

  origin {
        domain_name              = trimsuffix(trimprefix(aws_lambda_function_url.example.function_url, "https://"), "/")
    origin_id                = "lambda-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.lambda_oac.id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

Reference: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-lambda.html
Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/cloudfront-controls.html#cloudfront-16 for more details.
EOT
    }
}
