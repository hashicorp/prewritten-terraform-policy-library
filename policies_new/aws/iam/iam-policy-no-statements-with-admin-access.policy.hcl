# Copyright IBM Corp. 2026

# IAM policies should not allow full "*" administrative privileges

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "iam-policy-no-statements-with-admin-access-enforcement-level" {
  type    = string
  default = "advisory"
}

input "excludePermissionBoundaryPolicy_admin" {
  type    = string
  default = "false"
}

resource_policy "aws_iam_policy" "deny_full_admin_privileges" {
  enforcement_level = input.iam-policy-no-statements-with-admin-access-enforcement-level
  filter = attrs.policy != null

  locals {
    exclude     = input.excludePermissionBoundaryPolicy_admin == "true"
    policy_doc  = core::try(core::jsondecode(attrs.policy), null)
    statements  = [for stmt in core::flatten([core::try(local.policy_doc.Statement, [])]) : stmt]

    has_admin_access = core::length([
      for stmt in local.statements :
      stmt if (
        core::try(stmt.Effect, "") == "Allow" &&
        (core::try(stmt.Action, "") == "*" || core::try(core::contains(stmt.Action, "*"), false)) &&
        (core::try(stmt.Resource, "") == "*" || core::try(core::contains(stmt.Resource, "*"), false))
      )
    ]) > 0
  }

  # If this policy is used as a permissions boundary on a role and the caller
  # has opted out of checking boundaries, skip the admin-access check.
  # Terraform's reference graph resolves the connection via the reference edge
  # aws_iam_role.permissions_boundary = aws_iam_policy.X.arn — no string
  # comparison needed at plan time.
  connected "aws_iam_role" {
    connection {
      subject = "permissions_boundary"
      target  = "arn"
    }

    enforce {
      condition     = !local.exclude || !local.has_admin_access
      error_message = "IAM customer managed policy must not allow administrative wildcard access with Effect 'Allow', Action '*', and Resource '*'"
    }
  }

  connected "aws_iam_user" {
    connection {
      subject = "permissions_boundary"
      target  = "arn"
    }

    enforce {
      condition     = !local.exclude || !local.has_admin_access
      error_message = "IAM customer managed policy must not allow administrative wildcard access with Effect 'Allow', Action '*', and Resource '*'"
    }
  }

  # Also enforce for policies that are not used as a permissions boundary at all
  # (neither connected block fires if there are no matches).
  enforce {
    condition     = !local.has_admin_access
    error_message = "IAM customer managed policy must not allow administrative wildcard access with Effect 'Allow', Action '*', and Resource '*'"
  }
}
