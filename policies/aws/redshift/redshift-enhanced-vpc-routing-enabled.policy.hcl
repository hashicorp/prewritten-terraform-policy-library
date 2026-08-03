# Copyright IBM Corp. 2026

# Redshift.7 - Redshift clusters should use enhanced VPC routing. This control checks whether an Amazon Redshift cluster has EnhancedVpcRouting enabled.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "redshift-enhanced-vpc-routing-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_redshift_cluster" "enhanced_vpc_routing_enabled" {
    enforcement_level = input.redshift-enhanced-vpc-routing-enabled-enforcement-level
    enforce {
        condition = core::try(attrs.enhanced_vpc_routing, false) == true
        error_message = "Redshift cluster does not have enhanced VPC routing enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/redshift-controls.html#redshift-7 for more details."
    }
}