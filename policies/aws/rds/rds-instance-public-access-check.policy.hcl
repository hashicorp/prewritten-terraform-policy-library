# RDS.2 - RDS DB Instances should prohibit public access.

policy {}

input "rds-instance-public-access-check-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_db_instance" "public_access_prohibited" {
    enforcement_level = input.rds-instance-public-access-check-enforcement-level
    enforce {
        condition = core::try(attrs.publicly_accessible, false) == false
        error_message = "RDS DB Instance should prohibit public access. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-2 for more details."
    }
}
