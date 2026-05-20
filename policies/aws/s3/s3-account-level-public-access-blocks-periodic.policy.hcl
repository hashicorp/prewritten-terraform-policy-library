# S3.1 - S3 Block Public Access Settings Enabled. This control checks whether the preceding Amazon S3 block public access settings are configured at the account level for an S3 general purpose bucket. The control fails if one or more of the block public access settings are set to false.

policy {}

resource_policy "aws_s3_account_public_access_block" "block-public-access-enabled" {
    locals {
        block_public_acls = core::try(attrs.block_public_acls, true)
        block_public_policy = core::try(attrs.block_public_policy, true)
        ignore_public_acls = core::try(attrs.ignore_public_acls, true)
        restrict_public_buckets = core::try(attrs.restrict_public_buckets, true)
    }

    enforce {
        condition = local.block_public_acls && local.block_public_policy && local.ignore_public_acls && local.restrict_public_buckets
        error_message = "S3 account-level public access block must have ALL four settings enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-1 for more details."
    }
}