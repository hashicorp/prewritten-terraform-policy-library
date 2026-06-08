# Copyright IBM Corp. 2026

# RDS.10 - IAM authentication should be configured for RDS instances.

policy {}

resource_policy "aws_db_instance" "iam_database_authentication_enabled" {
    filter = core::contains(["mysql", "postgres", "aurora", "aurora-mysql", "aurora-postgresql", "mariadb"], core::try(attrs.engine, ""))

    locals {
        iam_authentication_enabled = core::try(attrs.iam_database_authentication_enabled, false)
    }

    enforce {
        condition = local.iam_authentication_enabled == true
        error_message = "RDS DB instance must enable iam_database_authentication_enabled for supported engines. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-10 for more details."
    }
}
