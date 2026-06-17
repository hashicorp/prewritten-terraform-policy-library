# Copyright IBM Corp. 2026

# RedshiftServerless.1: Amazon Redshift Serverless workgroups should use enhanced VPC routing

policy {}

input "redshift-serverless-workgroup-routes-within-vpc-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_redshiftserverless_workgroup" "enhanced_vpc_routing_required" {
    enforcement_level = input.redshift-serverless-workgroup-routes-within-vpc-enforcement-level
    locals {
        # Safely access enhanced_vpc_routing attribute with default false
        enhanced_vpc_routing = core::try(attrs.enhanced_vpc_routing, false)
    }

    enforce {
        condition     = local.enhanced_vpc_routing == true
        error_message = "Redshift Serverless workgroup must have enhanced VPC routing enabled. Set 'enhanced_vpc_routing = true' in the workgroup configuration to route traffic through the VPC instead of over the internet. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/redshiftserverless-controls.html#redshiftserverless-1 for more details."
    }
}
