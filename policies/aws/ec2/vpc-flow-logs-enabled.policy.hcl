# Copyright IBM Corp. 2026

# EC2.6 - VPC Flow Logging Should Be Enabled in All VPCs

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "vpc-flow-logs-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_vpc" "flow_logging_enabled" {
  enforcement_level = input.vpc-flow-logs-enabled-enforcement-level
  filter            = core::try(attrs.id, "") != ""

  connected "aws_flow_log" {
    min_instances = 1

    connection {
      subject   = "id"
      connected = "vpc_id"
    }

    filter = core::try(connected.aws_flow_log.traffic_type, "") == "REJECT"
  }
}
