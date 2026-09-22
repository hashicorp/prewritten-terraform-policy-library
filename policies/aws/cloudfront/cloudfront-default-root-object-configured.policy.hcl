# Copyright IBM Corp. 2026

# CloudFront distributions should have a default root object configured

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

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
            if ((core::try(origin.origin_access_control_id, null) != null ? origin.origin_access_control_id : "") != "") || core::try(origin.s3_origin_config, null) != null
        ]
        default_root_object = core::try(attrs.default_root_object, null) != null ? attrs.default_root_object : ""
        condition = core::length(local.s3_origins) > 0 ? local.default_root_object != "" : true
    }

    enforce {
        condition = local.condition
        error_message = "CloudFront distribution does not have a default root object configured"
    }
}
