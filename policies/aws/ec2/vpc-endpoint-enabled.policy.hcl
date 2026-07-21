# Copyright IBM Corp. 2026

# Policy : EC2.55 - VPCs should be configured with an interface endpoint for the services

policy {}

input "vpc-endpoint-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_vpc" "vpc_endpoint_required" {
  enforcement_level = input.vpc-endpoint-enabled-enforcement-level
  # Skip evaluation when the VPC id is unknown (e.g. plan-time computed value).
  filter = core::try(attrs.id, "") != ""

  connected "aws_vpc_endpoint" {
    min_instances = 1

    connection {
      subject   = "id"
      connected = "vpc_id"
    }

    filter = core::length(core::regexall("^com\\.amazonaws\\.[a-z0-9-]+\\.ecr\\.api(-fips)?$", core::try(connected.aws_vpc_endpoint.service_name, ""))) > 0
  }
}
