# RDS.6 - Enhanced monitoring should be configured for RDS DB instances

locals {
    valid_monitoring_intervals = [1, 5, 10, 15, 30, 60]
}

input "rds-enhanced-monitoring-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_db_instance" "enhanced_monitoring_enabled" {
    enforcement_level = input.rds-enhanced-monitoring-enabled-enforcement-level
    locals {
        interval = core::try(attrs.monitoring_interval, 0)
        is_valid_interval = core::contains(local.valid_monitoring_intervals, local.interval)
    }

    enforce {
        condition = local.is_valid_interval
        error_message = "Enhanced monitoring should be configured for RDS DB instances. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-6 for more details."
    }
}
