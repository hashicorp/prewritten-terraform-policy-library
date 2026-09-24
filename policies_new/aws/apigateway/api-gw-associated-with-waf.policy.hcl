# Copyright IBM Corp. 2026

# API Gateway should be associated with a WAF Web ACL

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "api-gw-associated-with-waf-enforcement-level" {
  type    = string
  default = "advisory"
}

# GAP 6 (composite subject path — not converted):
#
# The only blocker is connection.subject. No single attribute on
# aws_api_gateway_stage holds the full stage ARN that aws_wafv2_web_acl_association
# uses in resource_arn:
#   arn:aws:apigateway:{region}::/restapis/{rest_api_id}/stages/{stage_name}
#
# connection.subject must be a plain attribute path — not an interpolated
# expression — so there is nothing to put there.
#
# Note: a connected block without a connection block would be semantically
# equivalent to core::getresources with no filter — it would match every
# aws_wafv2_web_acl_association in the plan regardless of which stage it
# belongs to. That is not a valid conversion.
#
# The OR fallback (web_acl_arn set directly on the stage) is now expressible
# via Decision 10: connected.label.matched || attrs.web_acl_arn != "". That
# gap is resolved; only the composite subject path remains.

locals {
  all_waf_associations = core::getresources("aws_wafv2_web_acl_association", {})
}

resource_policy "aws_api_gateway_stage" "waf_association_required" {
  enforcement_level = input.api-gw-associated-with-waf-enforcement-level

  locals {
    stage_arn = "arn:aws:apigateway:*::/restapis/${attrs.rest_api_id}/stages/${attrs.stage_name}"

    matching_associations = [
      for assoc in local.all_waf_associations :
      assoc if core::try(assoc.resource_arn, "") == local.stage_arn
    ]
    has_waf_association = core::length(local.matching_associations) > 0

    web_acl_arn_value = core::try(attrs.web_acl_arn, "")
    has_web_acl_arn   = local.web_acl_arn_value != ""
  }

  enforce {
    condition     = local.has_waf_association || local.has_web_acl_arn
    error_message = "API Gateway stage '${attrs.rest_api_id}/${attrs.stage_name}' must be associated with an AWS WAF Web ACL. Create an aws_wafv2_web_acl_association resource with resource_arn pointing to this stage's ARN, or ensure the stage has a web_acl_arn configured"
  }
}
