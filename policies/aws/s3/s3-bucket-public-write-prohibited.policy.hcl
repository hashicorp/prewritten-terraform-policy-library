# Copyright IBM Corp. 2026

# S3 general purpose buckets should block public write access

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "s3-bucket-public-write-prohibited-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_s3_bucket" "bucket-public-write-prohibited" {
  enforcement_level = input.s3-bucket-public-write-prohibited-enforcement-level

  locals {
    bucket_name = core::try(attrs.bucket, "")
    matching_acls = core::getresources("aws_s3_bucket_acl", {
        bucket = local.bucket_name
    })
    matching_bucket_policies = core::getresources("aws_s3_bucket_policy", {
        bucket = local.bucket_name
    })
    matching_public_access_blocks = core::getresources("aws_s3_bucket_public_access_block", {
        bucket = local.bucket_name
    })

    has_acl = core::length(local.matching_acls) > 0
    final_acl = local.has_acl ? local.matching_acls[0] : null
    has_bucket_policy = core::length(local.matching_bucket_policies) > 0
    bucket_policy = local.has_bucket_policy ? local.matching_bucket_policies[0] : null
    has_public_access_block = core::length(local.matching_public_access_blocks) > 0
    public_access_block = local.has_public_access_block ? local.matching_public_access_blocks[0] : null

    block_public_policy = core::try(local.public_access_block.block_public_policy, false)
    block_public_acls = core::try(local.public_access_block.block_public_acls, false)
    ignore_public_acls = core::try(local.public_access_block.ignore_public_acls, false)

    acl_value = core::try(local.final_acl.acl, "")
    public_write_acl_values = ["public-read-write"]
    acl_has_public_write = core::contains(local.public_write_acl_values, local.acl_value)
    has_access_control_policy = local.has_acl && local.acl_value == "" && core::length(core::try(local.final_acl.access_control_policy, [])) > 0

    public_write_permissions = ["WRITE", "FULL_CONTROL"]
    public_acl_write_grants = local.has_access_control_policy ? [
      for grant in core::try(local.final_acl.access_control_policy[0].grant, []) : grant
      if core::try(grant.grantee[0].type, "") == "Group" &&
      core::contains(core::split("/", core::try(grant.grantee[0].uri, "")), "AllUsers") &&
      core::contains(local.public_write_permissions, core::try(grant.permission, ""))
    ] : []

    acl_condition = local.acl_has_public_write || core::length(local.public_acl_write_grants) > 0

    policy_doc = core::jsondecode(core::try(local.bucket_policy.policy, "{}"))
    public_write_statements = [
        for statement in core::try(local.policy_doc.Statement, []) : statement
        if core::try(statement.Effect, "") == "Allow" &&
        # Public / wildcard principal.
        (
            core::try(statement.Principal == "*", false) ||
            core::try(statement.Principal.AWS == "*", false) ||
            core::try(core::length([
                for principal in core::try(statement.Principal.AWS, []) : principal
                if principal == "*"
            ]) > 0, false)
        ) && 
        # Action grants object upload access.
        (
            core::try(statement.Action == "s3:PutObject", false) ||
            core::try( core::length([
                for action in core::try(statement.Action, []) : action
                if action == "s3:PutObject"
            ]) > 0, false) || 
            core::try(statement.Action == "s3:Put*", false) ||
            core::try(statement.Action == "s3:*", false) ||
            core::try(core::length([
                for action in core::try(statement.Action, []) : action
                if action == "s3:Put*" || action == "s3:*"
            ]) > 0, false)
        )
    ]
    

    policy_condition = core::length(local.public_write_statements) > 0

    policy_path_protected = local.block_public_policy || !local.policy_condition
    acl_path_protected = local.block_public_acls && local.ignore_public_acls || !local.acl_condition

    public_write_prohibited = local.policy_path_protected && local.acl_path_protected
  }

  enforce {
    condition     = local.public_write_prohibited
    error_message = "S3 bucket '${local.bucket_name}' permits public read access through its bucket policy or ACL"
  }
}