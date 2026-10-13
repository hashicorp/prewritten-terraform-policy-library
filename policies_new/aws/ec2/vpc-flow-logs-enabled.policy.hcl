# Copyright IBM Corp. 2026

# VPC flow logging should be enabled in all VPCs

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "vpc-flow-logs-enabled-enforcement-level" {
  type    = string
  default = "advisory"
}

locals {
  required_traffic_type = "REJECT"
}

resource_policy "aws_vpc" "flow_logging_enabled" {
  enforcement_level = input.vpc-flow-logs-enabled-enforcement-level

  # reverse=true: aws_flow_log.vpc_id is a user-declared attribute pointing at
  # this VPC. The engine finds all aws_flow_log resources whose vpc_id equals
  # the id of the current aws_vpc being evaluated.
  connected "aws_flow_log" {
    connection {
      reverse = true
      subject = "vpc_id"
      target  = "id"
    }

    cardinality = {
      min_matches   = 1
      error_message = "VPC must have VPC Flow Logs enabled. Create an aws_flow_log resource with vpc_id = ${attrs.id}"
    }
  }

  # Second connected block filters to only flow logs with the required traffic
  # type, asserting that at least one such log exists.
  connected "aws_flow_log" {
    where {
      traffic_type = local.required_traffic_type
    }

    connection {
      reverse = true
      subject = "vpc_id"
      target  = "id"
    }

    cardinality = {
      min_matches   = 1
      error_message = "VPC must have VPC Flow Logs with traffic_type set to '${local.required_traffic_type}'. Current flow logs do not capture the required rejected traffic"
    }
  }
}
