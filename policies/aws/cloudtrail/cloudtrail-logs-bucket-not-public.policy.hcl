# Copyright IBM Corp. 2026

# Ensure the S3 bucket used to store CloudTrail logs is not publicly accessible

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "cloudtrail-logs-bucket-not-public-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_cloudtrail" "cloudtrail_logs_bucket_not_public" {
  filter = core::try(attrs.s3_bucket_name, null) != null && core::try(attrs.s3_bucket_name, "") != ""

  locals {
    bucket_name = core::try(attrs.s3_bucket_name, "")

    # S3 Block Public Access
    public_access_blocks = core::getresources("aws_s3_bucket_public_access_block", {
      bucket = local.bucket_name
    })
    has_public_access_block = core::length(local.public_access_blocks) > 0

    public_access_block = local.has_public_access_block ? local.public_access_blocks[0] : null
    block_public_policy = core::try(local.public_access_block.block_public_policy, false)
    block_public_acls = core::try(local.public_access_block.block_public_acls, false)
    ignore_public_acls = core::try(local.public_access_block.ignore_public_acls, false)
    restrict_public_buckets = core::try(local.public_access_block.restrict_public_buckets, false)

    # AWS recommends all four settings for CloudTrail.6.
    all_public_access_block_settings_enabled = local.block_public_policy && local.block_public_acls && local.ignore_public_acls && local.restrict_public_buckets

    # Bucket ACL
    bucket_acls = core::getresources("aws_s3_bucket_acl", {
      bucket = local.bucket_name
    })
    has_bucket_acl = core::length(local.bucket_acls) > 0
    bucket_acl = local.has_bucket_acl ? local.bucket_acls[0] : null

    # Canned ACLs that provide public read access.
    public_acl_values = ["public-read", "public-read-write"]
    acl_value = core::try(local.bucket_acl.acl, "")
    acl_has_public_read = core::contains(local.public_acl_values, local.acl_value)

    access_control_policy = core::try(local.bucket_acl.access_control_policy, [])
    public_read_permissions = ["READ", "READ_ACP", "FULL_CONTROL"]
    public_acl_grants = local.has_bucket_acl ? [
      for grant in core::try(local.access_control_policy[0].grant, []) : grant
      if core::try(grant.grantee[0].type, "") == "Group" && core::contains(
        [
          "http://acs.amazonaws.com/groups/global/AllUsers",
          "http://acs.amazonaws.com/groups/global/AuthenticatedUsers"
        ], core::try(grant.grantee[0].uri, "")
      ) && core::contains(local.public_read_permissions, core::try(grant.permission, ""))
    ] : []

    acl_has_public_read_condition = local.acl_has_public_read || core::length(local.public_acl_grants) > 0

    # Inline aws_s3_bucket ACL
    buckets = core::getresources("aws_s3_bucket", {
        bucket = local.bucket_name
    })
    has_bucket = core::length(local.buckets) > 0
    bucket = local.has_bucket ? local.buckets[0] : null
    inline_acl_value = core::try(local.bucket.acl, "")
    inline_acl_has_public_read = core::contains(local.public_acl_values, local.inline_acl_value)

    # Bucket policy
    bucket_policies = core::getresources("aws_s3_bucket_policy", {
        bucket = local.bucket_name
    })
    has_bucket_policy = core::length(local.bucket_policies) > 0
    bucket_policy = local.has_bucket_policy ? local.bucket_policies[0] : null
    policy_doc = core::jsondecode(core::try(local.bucket_policy.policy, "{}"))
    public_read_actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetObjectAcl",
      "s3:Get*",
      "s3:*",
      "*"
    ]

    public_read_statements = [
      for statement in core::try(local.policy_doc.Statement, []) : statement
      if core::try(statement.Effect, "") == "Allow" && (
        # Principal: "*"
        core::try(statement.Principal == "*", false) ||
        # Principal: { "AWS": "*" }
        core::try(statement.Principal.AWS == "*", false) ||
        # Principal: { "AWS": ["*", "..."] }
        core::try(
          core::length([
            for principal in core::try(statement.Principal.AWS, []) : principal
            if principal == "*"
          ]) > 0, false
        )
      ) && (
        # Action is a string.
        core::try(core::contains(local.public_read_actions, statement.Action), false) ||
        # Action is a list.
        core::try(
          core::length([
            for action in core::try(statement.Action, []) : action
            if core::contains(local.public_read_actions, action)
          ]) > 0, false
        )
      )
    ]
    has_public_read_policy = core::length(local.public_read_statements) > 0

    # If BlockPublicPolicy is enabled, public bucket policies are blocked.
    # Otherwise, the actual bucket policy must not grant public read access.
    policy_path_protected = local.block_public_policy || !local.has_public_read_policy

    # If BlockPublicAcls + IgnorePublicAcls are enabled, public ACLs cannot
    # provide access. Otherwise, inspect the actual bucket ACL.
    acl_path_protected = (local.block_public_acls && local.ignore_public_acls) || (!local.acl_has_public_read_condition && !local.inline_acl_has_public_read)

    bucket_is_private = local.all_public_access_block_settings_enabled && local.policy_path_protected && local.acl_path_protected
  }

  enforcement_level = input.cloudtrail-logs-bucket-not-public-enforcement-level

  enforce {
    condition = local.bucket_is_private

    error_message = "S3 bucket used to store CloudTrail logs must not be publicly accessible. Enable all four S3 Block Public Access settings (block_public_acls, block_public_policy, ignore_public_acls, and restrict_public_buckets) and ensure the bucket policy and ACL do not grant public read access."
  }
}
