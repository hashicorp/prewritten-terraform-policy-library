# Copyright IBM Corp. 2026

# RDS.14 - Amazon Aurora clusters should have backtracking enabled.

policy {}

resource_policy "aws_rds_cluster" "backtracking_enabled" {
    filter = core::try(attrs.engine, "") == "aurora-mysql"
    locals {
        backtrack_window = core::try(attrs.backtrack_window, 0)
    }
    enforce {
        condition = local.backtrack_window > 0 && local.backtrack_window <= 259200
        error_message = "Amazon Aurora clusters should have backtracking enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-14 for more details."
    }
}
