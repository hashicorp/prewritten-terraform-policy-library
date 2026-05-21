# Neptune.4 - Neptune DB clusters should have deletion protection enabled.

policy {}

resource_policy "aws_neptune_cluster" "deletion-protection-enabled" {
    enforce {
        condition = core::try(attrs.deletion_protection, false)
        error_message = "The Neptune cluster does not have deletion protection enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/neptune-controls.html#neptune-4 for more details."
    }
}