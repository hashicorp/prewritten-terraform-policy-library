# Copyright IBM Corp. 2026

# Policy: EC2.10 - Amazon EC2 should be configured to use VPC endpoints

policy {}

input "service-vpc-endpoint-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

# Validate each VPC has an EC2 interface endpoint.
resource_policy "aws_vpc" "ec2_service_vpc_endpoint_enabled" {
  enforcement_level = input.service-vpc-endpoint-enabled-enforcement-level
  filter            = core::try(attrs.id, "") != ""

  connected "aws_vpc_endpoint" {
    min_instances = 1

    connection {
      subject   = "id"
      connected = "vpc_id"
    }

    filter = (
      core::try(connected.aws_vpc_endpoint.vpc_endpoint_type, "") == "Interface" &&
      core::length(core::regexall("\\.ec2(-fips)?$", core::try(connected.aws_vpc_endpoint.service_name, ""))) > 0 &&
      core::length(core::try(connected.aws_vpc_endpoint.subnet_ids, [])) > 0 &&
      core::length(core::try(connected.aws_vpc_endpoint.security_group_ids, [])) > 0
    )
  }
}
