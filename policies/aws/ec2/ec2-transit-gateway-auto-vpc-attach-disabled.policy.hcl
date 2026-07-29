# Copyright IBM Corp. 2026

# EC2.23 - Transit Gateway Auto-Accept VPC Attachments

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "ec2-transit-gateway-auto-vpc-attach-disabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_ec2_transit_gateway" "auto_accept_disabled" {
    enforcement_level = input.ec2-transit-gateway-auto-vpc-attach-disabled-enforcement-level
    locals {

        # Safe access to auto_accept_shared_attachments attribute
        auto_accept = core::try(attrs.auto_accept_shared_attachments, "disable")
        
        # Check if auto-accept is disabled (compliant)
        is_compliant = local.auto_accept == "disable"
    }

    enforce {
        condition     = local.is_compliant
        error_message = "Transit Gateway must not automatically accept shared VPC attachments. Current setting: '${local.auto_accept}'. Set 'auto_accept_shared_attachments' to 'disable' or omit it (defaults to 'disable'). Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-23 for more details."
    }
}
