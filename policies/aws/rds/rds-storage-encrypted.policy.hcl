# RDS.3 - RDS DB instances should have encryption at-rest enabled.

policy {}

resource_policy "aws_db_instance" "storage_encrypted" {
    enforce {
        condition = core::try(attrs.storage_encrypted, false) == true
        error_message = "RDS DB instances should have encryption at-rest enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-3 for more details."
    }
}
