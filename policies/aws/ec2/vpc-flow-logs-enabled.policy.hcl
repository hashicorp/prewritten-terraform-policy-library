# Copyright IBM Corp. 2026

# EC2.6 - VPC Flow Logging Should Be Enabled in All VPCs

policy {}

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
