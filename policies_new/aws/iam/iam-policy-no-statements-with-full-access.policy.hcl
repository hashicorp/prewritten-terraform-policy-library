# Copyright IBM Corp. 2026

# IAM customer managed policies that you create should not allow wildcard actions for services

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "iam-policy-no-statements-with-full-access-enforcement-level" {
  type    = string
  default = "advisory"
}

input "excludePermissionBoundaryPolicy" {
  type    = string
  default = "false"
}

locals {
  valid_exclude_input = input.excludePermissionBoundaryPolicy == "true" || input.excludePermissionBoundaryPolicy == "false"
}

resource_policy "aws_iam_policy" "deny_service_wildcards" {
  enforcement_level = input.iam-policy-no-statements-with-full-access-enforcement-level

  locals {
    exclude      = input.excludePermissionBoundaryPolicy == "true"
    policy_json  = core::try(core::jsondecode(attrs.policy), {})
    statements   = [for statement in core::try(local.policy_json.Statement, []) : statement]
    policy_name  = core::try(attrs.name, "unnamed-policy")

    violating_actions = [
      for statement in local.statements :
      statement if core::try(statement.Effect, "") == "Allow" && (
        core::try(core::length([for action in core::try(statement.Action, []) : action if core::length(core::regexall("^[^:*]+:\\*$", action)) > 0]), 0) > 0 ||
        core::try(core::length(core::regexall("^[^:*]+:\\*$", core::try(statement.Action, ""))), 0) > 0
      )
    ]

    violating_not_actions = [
      for statement in local.statements :
      statement if core::try(statement.Effect, "") == "Allow" && (
        core::try(core::length([for action in core::try(statement.NotAction, []) : action if core::length(core::regexall("^[^:*]+:\\*$", action)) > 0]), 0) > 0 ||
        core::try(core::length(core::regexall("^[^:*]+:\\*$", core::try(statement.NotAction, ""))), 0) > 0
      )
    ]
  }

  enforce {
    condition     = local.valid_exclude_input
    error_message = "input.excludePermissionBoundaryPolicy must be 'true' or 'false'. Current value: '${input.excludePermissionBoundaryPolicy}'."
  }

  # If this policy is used as a permissions boundary on a role/user and the
  # caller has opted out, skip the wildcard check for that match.
  # Connection follows the reference edge: aws_iam_role.permissions_boundary = aws_iam_policy.X.arn
  connected "aws_iam_role" {
    connection {
      subject = "permissions_boundary"
      target  = "arn"
    }

    enforce {
      condition     = !local.exclude || core::length(local.violating_actions) == 0
      error_message = "IAM policy '${local.policy_name}' must not allow full service wildcard actions such as 'ec2:*' in Allow statements"
    }

    enforce {
      condition     = !local.exclude || core::length(local.violating_not_actions) == 0
      error_message = "IAM policy '${local.policy_name}' must not use NotAction with full service wildcards such as 'ec2:*' in Allow statements"
    }
  }

  connected "aws_iam_user" {
    connection {
      subject = "permissions_boundary"
      target  = "arn"
    }

    enforce {
      condition     = !local.exclude || core::length(local.violating_actions) == 0
      error_message = "IAM policy '${local.policy_name}' must not allow full service wildcard actions such as 'ec2:*' in Allow statements"
    }

    enforce {
      condition     = !local.exclude || core::length(local.violating_not_actions) == 0
      error_message = "IAM policy '${local.policy_name}' must not use NotAction with full service wildcards such as 'ec2:*' in Allow statements"
    }
  }

  # Also enforce for policies not used as a permissions boundary at all.
  enforce {
    condition     = core::length(local.violating_actions) == 0
    error_message = "IAM policy '${local.policy_name}' must not allow full service wildcard actions such as 'ec2:*' in Allow statements"
  }

  enforce {
    condition     = core::length(local.violating_not_actions) == 0
    error_message = "IAM policy '${local.policy_name}' must not use NotAction with full service wildcards such as 'ec2:*' in Allow statements"
  }
}

resource_policy "aws_iam_role_policy" "deny_service_wildcards" {
  enforcement_level = input.iam-policy-no-statements-with-full-access-enforcement-level

  locals {
    policy_json = core::try(core::jsondecode(attrs.policy), {})
    statements  = [for statement in core::try(local.policy_json.Statement, []) : statement]

    violating_actions = [
      for statement in local.statements :
      statement if core::try(statement.Effect, "") == "Allow" && (
        core::try(core::length([for action in core::try(statement.Action, []) : action if core::length(core::regexall("^[^:*]+:\\*$", action)) > 0]), 0) > 0 ||
        core::try(core::length(core::regexall("^[^:*]+:\\*$", core::try(statement.Action, ""))), 0) > 0
      )
    ]

    violating_not_actions = [
      for statement in local.statements :
      statement if core::try(statement.Effect, "") == "Allow" && (
        core::try(core::length([for action in core::try(statement.NotAction, []) : action if core::length(core::regexall("^[^:*]+:\\*$", action)) > 0]), 0) > 0 ||
        core::try(core::length(core::regexall("^[^:*]+:\\*$", core::try(statement.NotAction, ""))), 0) > 0
      )
    ]
  }

  enforce {
    condition     = local.valid_exclude_input
    error_message = "input.excludePermissionBoundaryPolicy must be 'true' or 'false'. Current value: '${input.excludePermissionBoundaryPolicy}'."
  }

  enforce {
    condition     = core::length(local.violating_actions) == 0
    error_message = "IAM role inline policy '${core::try(attrs.name, "unnamed-role-policy")}' must not allow full service wildcard actions such as 'ec2:*' in Allow statements"
  }

  enforce {
    condition     = core::length(local.violating_not_actions) == 0
    error_message = "IAM role inline policy '${core::try(attrs.name, "unnamed-role-policy")}' must not use NotAction with full service wildcards such as 'ec2:*' in Allow statements"
  }
}

resource_policy "aws_iam_user_policy" "deny_service_wildcards" {
  enforcement_level = input.iam-policy-no-statements-with-full-access-enforcement-level

  locals {
    policy_json = core::try(core::jsondecode(attrs.policy), {})
    statements  = [for statement in core::try(local.policy_json.Statement, []) : statement]

    violating_actions = [
      for statement in local.statements :
      statement if core::try(statement.Effect, "") == "Allow" && (
        core::try(core::length([for action in core::try(statement.Action, []) : action if core::length(core::regexall("^[^:*]+:\\*$", action)) > 0]), 0) > 0 ||
        core::try(core::length(core::regexall("^[^:*]+:\\*$", core::try(statement.Action, ""))), 0) > 0
      )
    ]

    violating_not_actions = [
      for statement in local.statements :
      statement if core::try(statement.Effect, "") == "Allow" && (
        core::try(core::length([for action in core::try(statement.NotAction, []) : action if core::length(core::regexall("^[^:*]+:\\*$", action)) > 0]), 0) > 0 ||
        core::try(core::length(core::regexall("^[^:*]+:\\*$", core::try(statement.NotAction, ""))), 0) > 0
      )
    ]
  }

  enforce {
    condition     = local.valid_exclude_input
    error_message = "input.excludePermissionBoundaryPolicy must be 'true' or 'false'. Current value: '${input.excludePermissionBoundaryPolicy}'."
  }

  enforce {
    condition     = core::length(local.violating_actions) == 0
    error_message = "IAM user inline policy '${core::try(attrs.name, "unnamed-user-policy")}' must not allow full service wildcard actions such as 'ec2:*' in Allow statements"
  }

  enforce {
    condition     = core::length(local.violating_not_actions) == 0
    error_message = "IAM user inline policy '${core::try(attrs.name, "unnamed-user-policy")}' must not use NotAction with full service wildcards such as 'ec2:*' in Allow statements"
  }
}

resource_policy "aws_iam_group_policy" "deny_service_wildcards" {
  enforcement_level = input.iam-policy-no-statements-with-full-access-enforcement-level

  locals {
    policy_json = core::try(core::jsondecode(attrs.policy), {})
    statements  = [for statement in core::try(local.policy_json.Statement, []) : statement]

    violating_actions = [
      for statement in local.statements :
      statement if core::try(statement.Effect, "") == "Allow" && (
        core::try(core::length([for action in core::try(statement.Action, []) : action if core::length(core::regexall("^[^:*]+:\\*$", action)) > 0]), 0) > 0 ||
        core::try(core::length(core::regexall("^[^:*]+:\\*$", core::try(statement.Action, ""))), 0) > 0
      )
    ]

    violating_not_actions = [
      for statement in local.statements :
      statement if core::try(statement.Effect, "") == "Allow" && (
        core::try(core::length([for action in core::try(statement.NotAction, []) : action if core::length(core::regexall("^[^:*]+:\\*$", action)) > 0]), 0) > 0 ||
        core::try(core::length(core::regexall("^[^:*]+:\\*$", core::try(statement.NotAction, ""))), 0) > 0
      )
    ]
  }

  enforce {
    condition     = local.valid_exclude_input
    error_message = "input.excludePermissionBoundaryPolicy must be 'true' or 'false'. Current value: '${input.excludePermissionBoundaryPolicy}'."
  }

  enforce {
    condition     = core::length(local.violating_actions) == 0
    error_message = "IAM group inline policy '${core::try(attrs.name, "unnamed-group-policy")}' must not allow full service wildcard actions such as 'ec2:*' in Allow statements"
  }

  enforce {
    condition     = core::length(local.violating_not_actions) == 0
    error_message = "IAM group inline policy '${core::try(attrs.name, "unnamed-group-policy")}' must not use NotAction with full service wildcards such as 'ec2:*' in Allow statements"
  }
}
