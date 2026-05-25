# RDS.7 - RDS clusters should have deletion protection enabled.

policy {}

resource_policy "aws_rds_cluster" "deletion_protection_enabled" {
    enforce {
        condition = core::try(attrs.deletion_protection, false)
        error_message = "RDS clusters should have deletion protection enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-7 for more details."
    }
}
