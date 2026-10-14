# Copyright IBM Corp. 2026

# Application Load Balancers should be associated with an AWS WAF web ACL
policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "application-load-balancers-should-be-associated-with-an-aws-waf-web-acl-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_lb" "alb_associated_with_waf_web_acl" {
  filter = core::try(attrs.load_balancer_type, "application") == "application"

  locals {
    load_balancer_arn_raw = core::try(attrs.arn, null)
    load_balancer_arn     = local.load_balancer_arn_raw != null ? local.load_balancer_arn_raw : ""
    v2_associations       = core::getresources("aws_wafv2_web_acl_association", {})
    regional_associations = core::getresources("aws_wafregional_web_acl_association", {})
    associations          = core::concat(local.v2_associations, local.regional_associations)
    matching_associations = [
      for association in local.associations : association
      if local.load_balancer_arn != ""
        && core::try(association.resource_arn, "") == local.load_balancer_arn
    ]
    is_associated = core::length(local.matching_associations) > 0
  }

  enforcement_level = input.application-load-balancers-should-be-associated-with-an-aws-waf-web-acl-enforcement-level
  enforce {
    condition     = local.is_associated
    error_message = "Application Load Balancers must have an aws_wafv2_web_acl_association or aws_wafregional_web_acl_association whose resource_arn matches the load balancer ARN."
  }
}
