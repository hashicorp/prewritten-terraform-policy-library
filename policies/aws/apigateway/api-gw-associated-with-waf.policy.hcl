# Copyright IBM Corp. 2026

# APIGateway.4 - API Gateway should be associated with a WAF Web ACL

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "api-gw-associated-with-waf-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_api_gateway_stage" "waf_association_required" {
  enforcement_level = input.api-gw-associated-with-waf-enforcement-level
  filter            = core::try(attrs.web_acl_arn, "") == ""

  connected "aws_wafv2_web_acl_association" {
    connection {
      subject   = "arn"
      connected = "resource_arn"
    }

    min_instances = 1
  }
}
