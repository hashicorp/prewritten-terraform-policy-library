# Copyright IBM Corp. 2026

# Ensure access to AWSCloudShellFullAccess is restricted

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

locals {
  cloudshell_full_access_arn = "arn:aws:iam::aws:policy/AWSCloudShellFullAccess"
}

resource_policy "aws_iam_user_policy_attachment" "restrict_cloudshell_full_access" {
  enforcement_level = "advisory"
  enforce {
    condition     = core::try(attrs.policy_arn, "") != local.cloudshell_full_access_arn
    error_message = "IAM users must not have the AWSCloudShellFullAccess managed policy attached. Remove this policy attachment and grant only required CloudShell actions."
  }
}

resource_policy "aws_iam_group_policy_attachment" "restrict_cloudshell_full_access" {
  enforcement_level = "advisory"
  enforce {
    condition     = core::try(attrs.policy_arn, "") != local.cloudshell_full_access_arn
    error_message = "IAM groups must not have the AWSCloudShellFullAccess managed policy attached. Remove this policy attachment and grant only required CloudShell actions."
  }
}

resource_policy "aws_iam_role_policy_attachment" "restrict_cloudshell_full_access" {
  enforcement_level = "advisory"
  enforce {
    condition     = core::try(attrs.policy_arn, "") != local.cloudshell_full_access_arn
    error_message = "IAM roles must not have the AWSCloudShellFullAccess managed policy attached. Remove this policy attachment and grant only required CloudShell actions."
  }
}

resource_policy "aws_iam_user_policy" "restrict_unrestricted_cloudshell_actions" {
  locals {
    policy_raw           = core::try(attrs.policy, null)
    policy               = local.policy_raw != null ? local.policy_raw : "{}"
    policy_document      = core::try(core::jsondecode(local.policy), { Statement = [] })
    statements_raw       = core::try(local.policy_document.Statement, null)
    statements      = local.statements_raw != null ? local.statements_raw : []
    violating_statements = [
      for statement in local.statements : statement
      if core::try(statement.Effect, "") == "Allow" &&
      core::contains(
        core::try(
          [for action in statement.Action : core::lower(action)],
          [core::lower(statement.Action)]
        ),
        "cloudshell:*"
      )
    ]
  }

  enforcement_level = "advisory"
  enforce {
    condition     = core::length(local.violating_statements) == 0
    error_message = "IAM user inline policies must not allow cloudshell:*. Replace the wildcard with only the specific CloudShell actions required."
  }
}

resource_policy "aws_iam_group_policy" "restrict_unrestricted_cloudshell_actions" {
  locals {
    policy_raw           = core::try(attrs.policy, null)
    policy               = local.policy_raw != null ? local.policy_raw : "{}"
    policy_document      = core::try(core::jsondecode(local.policy), { Statement = [] })
    statements_raw       = core::try(local.policy_document.Statement, null)
    statements      = local.statements_raw != null ? local.statements_raw : []
    violating_statements = [
      for statement in local.statements : statement
      if core::try(statement.Effect, "") == "Allow" &&
      core::contains(
        core::try(
          [for action in statement.Action : core::lower(action)],
          [core::lower(statement.Action)]
        ),
        "cloudshell:*"
      )
    ]
  }

  enforcement_level = "advisory"
  enforce {
    condition     = core::length(local.violating_statements) == 0
    error_message = "IAM group inline policies must not allow cloudshell:*. Replace the wildcard with only the specific CloudShell actions required."
  }
}

resource_policy "aws_iam_role_policy" "restrict_unrestricted_cloudshell_actions" {
  locals {
    policy_raw           = core::try(attrs.policy, null)
    policy               = local.policy_raw != null ? local.policy_raw : "{}"
    policy_document      = core::try(core::jsondecode(local.policy), { Statement = [] })
    statements_raw       = core::try(local.policy_document.Statement, null)
    statements      = local.statements_raw != null ? local.statements_raw : []
    violating_statements = [
      for statement in local.statements : statement
      if core::try(statement.Effect, "") == "Allow" &&
      core::contains(
        core::try(
          [for action in statement.Action : core::lower(action)],
          [core::lower(statement.Action)]
        ),
        "cloudshell:*"
      )
    ]
  }

  enforcement_level = "advisory"
  enforce {
    condition     = core::length(local.violating_statements) == 0
    error_message = "IAM role inline policies must not allow cloudshell:*. Replace the wildcard with only the specific CloudShell actions required."
  }
}
