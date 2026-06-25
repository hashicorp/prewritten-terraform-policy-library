# Copyright IBM Corp. 2026

# Policy: RDS.2 - RDS DB Instances should prohibit public access, as determined by the PubliclyAccessible configuration

policy {}

input "rds-instance-public-access-check-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_db_instance" "rds-instance-should-be-private" {
  enforcement_level = input.rds-instance-public-access-check-enforcement-level
  locals {
    publicly_accessible_raw = core::try(attrs.publicly_accessible, false)
    publicly_accessible     = local.publicly_accessible_raw == null ? false : local.publicly_accessible_raw
  }

  enforce {
    condition     = !local.publicly_accessible
    error_message = "Attribute 'publicly_accessible' should be false for aws_db_instance resource. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-2 for more details."
  }
}
