# Copyright IBM Corp. 2026

# S3.2 - S3 General Purpose Buckets Should Block Public Read Access. This control checks whether an Amazon S3 general purpose bucket permits public read access. It evaluates the block public access settings, the bucket policy, and the bucket access control list (ACL). The control fails if the bucket permits public read access.

policy {}

resource_policy "aws_s3_bucket_acl" "bucket-public-read-acls-prohibited" {
    locals {
        invalid_acl_values = ["public-read", "public-read-write"]
        invalid_acl = core::try(attrs.acl, "")
        has_acl = local.invalid_acl != ""
        final_acl = local.has_acl ? local.invalid_acl : "private"
        condition = core::contains(local.invalid_acl_values, local.final_acl)

        has_access_control_policy = local.has_acl ? false : core::length(core::try(attrs.access_control_policy, [])) > 0
        invalid_permissions = ["READ", "READ_ACP", "FULL_CONTROL"]
        
        public_grants = local.has_access_control_policy ? [
            for grant in core::try(attrs.access_control_policy[0].grant, []) : grant
            if core::try(grant.grantee[0].type, "") == "Group" &&
            (core::contains(core::split("/", core::try(grant.grantee[0].uri, "")), "AllUsers") || core::contains(core::split("/", core::try(grant.grantee[0].uri, "")), "AuthenticatedUsers")) &&
            core::contains(local.invalid_permissions, core::try(grant.permission, ""))
        ] : []
        
        has_public_grants = core::length(local.public_grants) > 0
    }

    enforce {
        condition = !local.condition
        error_message = "S3 bucket has an invalid ACL. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-2 for more details."
    }

    enforce {
        condition = !local.has_public_grants
        error_message = "S3 bucket has public access granted to AllUsers. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-2 for more details."
    }
}

resource_policy "aws_s3_bucket_public_access_block" "bucket-public-read-prohibited" {
    locals {
        block_public_acls = core::try(attrs.block_public_acls, false)
        block_public_policy = core::try(attrs.block_public_policy, false)
        ignore_public_acls = core::try(attrs.ignore_public_acls, false)
        restrict_public_buckets = core::try(attrs.restrict_public_buckets, false)
    }

    enforce {
        condition = local.block_public_acls && local.block_public_policy && local.ignore_public_acls && local.restrict_public_buckets
        error_message = "S3 bucket does not have any Block Public Access settings enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/s3-controls.html#s3-2 for more details."
    }
}