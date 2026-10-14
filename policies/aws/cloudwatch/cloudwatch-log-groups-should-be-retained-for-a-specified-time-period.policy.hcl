# Copyright IBM Corp. 2026

# CloudWatch log groups should be retained for a specified time period

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.65.0, < 7.0.0"
    }
  }
}

input "cloudwatch-log-groups-should-be-retained-for-a-specified-time-period-enforcement-level" {
  type    = string
  default = "advisory"
}

input "minRetentionTime" {
  type    = number
  default = 365
}

resource_policy "aws_cloudwatch_log_group" "retention_period" {
  locals {
    retention_raw = core::try(attrs.retention_in_days, null)
    retention     = local.retention_raw != null ? local.retention_raw : 0
    log_group_class = core::try(attrs.log_group_class, "STANDARD")
    valid_minimums  = [365, 400, 545, 731, 1827, 3653]
    is_valid_minimum = core::contains(local.valid_minimums, input.minRetentionTime)
    is_delivery_class = local.log_group_class == "DELIVERY"
    is_compliant = (
      local.is_delivery_class
      || (
        local.is_valid_minimum
        && (local.retention == 0 || local.retention >= input.minRetentionTime)
      )
    )
  }

  enforcement_level = input.cloudwatch-log-groups-should-be-retained-for-a-specified-time-period-enforcement-level
  enforce {
    condition     = local.is_compliant
    error_message = "CloudWatch Log Groups should meet minRetentionTime (365, 400, 545, 731, 1827, or 3653 days), or use 0 for never expire. DELIVERY log groups are exempt because their retention is fixed at 2 days."
  }
}
