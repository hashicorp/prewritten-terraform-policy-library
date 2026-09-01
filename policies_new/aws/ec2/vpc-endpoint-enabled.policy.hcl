# Copyright IBM Corp. 2026

# VPCs should be configured with an interface endpoint for ECR API

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "vpc-endpoint-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_vpc" "vpc_endpoint_required" {
  enforcement_level = input.vpc-endpoint-enabled-enforcement-level
  filter = core::try(attrs.id, "") != ""

  locals {
    service_names = "ecr.api"
    raw_services  = [for s in core::split(",", local.service_names) : core::trimspace(s)]

    # Build a regex pattern per required service. If the user already supplied
    # the full com.amazonaws. prefix it is used as-is; otherwise the region
    # wildcard is prepended. A -fips suffix variant is always accepted.
    service_patterns = [
      for s in local.raw_services :
      (core::length(core::regexall("^com\\.amazonaws\\.", s)) > 0
        ? "^${s}(-fips)?$"
        : "^com\\.amazonaws\\.[a-z0-9-]+\\.${s}(-fips)?$")
    ]
  }

  # for_each iterates over local.service_patterns (a policy local, not a subject
  # attribute). Each iteration is one required service; the connected block finds
  # all aws_vpc_endpoint resources for this VPC and cardinality asserts that at
  # least one of them has a service_name matching the pattern for this iteration.
  connected "aws_vpc_endpoint" {
    for_each = local.service_patterns

    connection {
      reverse = true
      subject = "vpc_id"
      target  = "id"
    }

    cardinality = {
      min_matches   = 1
      error_message = "VPC is missing a VPC endpoint for service '${local.raw_services[each.index]}'. Expected a com.amazonaws.<region>.${local.raw_services[each.index]} endpoint."
    }

    enforce {
      # self = one matched aws_vpc_endpoint for this VPC.
      # each.value = the regex pattern for the current required service.
      condition     = core::length(core::regexall(each.value, core::try(self.service_name, ""))) > 0
      error_message = "VPC endpoint ${self.id} (service '${self.service_name}') does not match the required service pattern for '${local.raw_services[each.index]}'"
    }
  }
}
