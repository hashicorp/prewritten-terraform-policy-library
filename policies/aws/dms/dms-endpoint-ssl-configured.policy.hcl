# Copyright IBM Corp. 2026

# DMS endpoints should use SSL

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "dms-endpoint-ssl-configured-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_dms_endpoint" "certificate_arn_required" {
  enforcement_level = input.dms-endpoint-ssl-configured-enforcement-level
  locals {
    ssl_mode = core::try(attrs.ssl_mode, "none")
  }

  enforce {
    condition = local.ssl_mode != "none" 
    error_message = "Attribute 'ssl_mode' must be set to any of 'require', 'verify-ca' or 'verify-full' for 'aws_dms_endpoint' resources."
  }
}
