# Copyright IBM Corp. 2026

# RDS.5 - RDS DB instances should be configured with multiple Availability Zones.

policy {}

input "rds-multi-az-support-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_db_instance" "multi_az_support" {
    enforcement_level = input.rds-multi-az-support-enforcement-level
    enforce {
        condition = core::try(attrs.multi_az, false) == true
        error_message = "RDS DB instances should be configured with multiple Availability Zones. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-5 for more details."
    }
}
