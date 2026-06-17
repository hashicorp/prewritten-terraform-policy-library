# Copyright IBM Corp. 2026

# RDS.12 - IAM Authentication Should Be Configured for RDS Clusters.

policy {}

input "rds-cluster-iam-authentication-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_rds_cluster" "iam_authentication_enabled" {
    enforcement_level = input.rds-cluster-iam-authentication-enabled-enforcement-level
    enforce {
        condition = core::try(attrs.iam_database_authentication_enabled, false)
        error_message = "RDS cluster does not have IAM database authentication enabled. Set 'iam_database_authentication_enabled = true' to enable password-free authentication with IAM. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-12 for more details."
    }
}
