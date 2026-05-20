# Neptune.7 - Neptune DB clusters should have IAM database authentication enabled.

policy {}

resource_policy "aws_neptune_cluster" "iam-database-authentication" {
    enforce {
        condition = core::try(attrs.iam_database_authentication_enabled, false)
        error_message = "The Neptune DB cluster does not have IAM database authentication enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/neptune-controls.html#neptune-7 for more details."
    }
}
