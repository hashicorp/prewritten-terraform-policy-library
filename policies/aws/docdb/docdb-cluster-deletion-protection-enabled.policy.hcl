# DocumentDB.5 - Amazon DocumentDB clusters should have deletion protection enabled.

policy {}

resource_policy "aws_docdb_cluster" "deletion-protection-enabled" {
    enforce {
        condition = core::try(attrs.deletion_protection, false)
        error_message = "The DocumentDB cluster does not have deletion protection enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/documentdb-controls.html#documentdb-5 for more details."
    }
}