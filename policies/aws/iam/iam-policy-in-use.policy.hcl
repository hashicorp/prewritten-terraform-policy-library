# Ensure a support role has been created to manage incidents with AWS Support

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

locals {
  support_policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
}

resource_policy "aws_iam_group_policy_attachment" "support_access_on_group" {
  operations = ["create", "update"]
  locals {
    policy_arn_raw = core::try(attrs.policy_arn, null)
    policy_arn = local.policy_arn_raw != null ? local.policy_arn_raw : ""
    group_raw = core::try(attrs.group, null)
    group     = local.group_raw != null ? local.group_raw : ""

    group_memberships = core::getresources("aws_iam_group_membership", {
      group = local.group
    })
    qualifying_memberships = [
      for membership in local.group_memberships : membership
      if core::length(core::try(membership.users, [])) > 0
    ]
  }

  enforcement_level = "advisory"
  enforce {
    condition     = local.policy_arn != local.support_policy_arn || (local.group != "" && core::length(local.qualifying_memberships) > 0)
    error_message = "When AWSSupportAccess is attached to an IAM group, the group must contain at least one IAM user."
  }
}

resource_policy "aws_iam_role_policy_attachment" "support_access_on_role" {
  operations = ["create", "update"]

  locals {
    policy_arn_raw = core::try(attrs.policy_arn, null)
    policy_arn = local.policy_arn_raw != null ? local.policy_arn_raw : ""
    role_raw   = core::try(attrs.role, null)
    role       = local.role_raw != null ? local.role_raw : ""

    roles = core::getresources("aws_iam_role", {
      name = local.role
    })
    qualifying_roles = [
      for role_resource in local.roles : role_resource
      if core::contains_substring(core::try(role_resource.assume_role_policy, ""), "Principal") &&
        (core::contains_substring(core::try(role_resource.assume_role_policy, ""), "sts:AssumeRole") ||
        core::contains_substring(core::try(role_resource.assume_role_policy, ""), "sts:AssumeRoleWithSAML") ||
        core::contains_substring( core::try(role_resource.assume_role_policy, ""), "sts:AssumeRoleWithWebIdentity"))
    ]
  }

  enforcement_level = "advisory"

  enforce {
    condition     = local.policy_arn != local.support_policy_arn || (local.role != "" && core::length(local.qualifying_roles) > 0)
    error_message = "When AWSSupportAccess is attached to an IAM role, the role must have a trusted principal and an STS assume-role action in its assume_role_policy."
  }
}
