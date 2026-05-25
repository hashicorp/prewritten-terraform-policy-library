# Policy: EFS.4 - EFS access points should enforce a user identity

policy {}

resource_policy "aws_efs_access_point" "enforce_user_identity" {
    locals {
        posix_user_block = core::try(attrs.posix_user[0], null)

        has_posix_user = local.posix_user_block != null
        uid            = core::try(local.posix_user_block.uid, null)
        gid            = core::try(local.posix_user_block.gid, null)
    }

    enforce {
        condition     = local.has_posix_user
        error_message = "EFS access point must define a posix_user block to enforce user identity (EFS.4). Add a posix_user block with uid and gid. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/efs-controls.html#efs-4 for more details."
    }

    enforce {
        condition     = !local.has_posix_user || (local.uid != null && local.gid != null)
        error_message = "EFS access point configuration is missing required uid and/or gid values in the posix_user block. Both must be set to enforce user identity (EFS.4). Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/efs-controls.html#efs-4 for more details."
    }
}
