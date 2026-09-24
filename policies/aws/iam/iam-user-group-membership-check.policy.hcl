# Copyright IBM Corp. 2026

# Ensure users Receive Permissions Only Through Groups

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "iam-user-group-membership-check-enforcement-level" {
  type = string
  default = "advisory"
}

input "iam-user-group-membership-check-group-names" {
  type = list(string)
  default = []
}

resource_policy "aws_iam_user" "iam_user_group_membership_check" {
  enforcement_level = input.iam-user-group-membership-check-enforcement-level

  locals {
    user_name_raw = core::try(attrs.name, null)
    user_name = local.user_name_raw != null ? local.user_name_raw : ""
    memberships = core::getresources("aws_iam_user_group_membership", {
      user = local.user_name
    })
    user_groups = [
      for membership in local.memberships : membership.groups
      if core::length(core::try(membership.groups, [])) > 0
    ]
    has_group_membership = core::length(local.user_groups) > 0

    has_required_groups = core::length([
      for required_group in input.iam-user-group-membership-check-group-names : required_group
      if core::length([
        for groups in local.user_groups : groups
        if core::contains(groups, required_group)
      ]) > 0
    ]) == core::length(input.iam-user-group-membership-check-group-names)

    group_check_passes = core::length(input.iam-user-group-membership-check-group-names) == 0 ? local.has_group_membership : local.has_required_groups
  }

  enforce {
  condition = local.user_name != "" && local.group_check_passes
  error_message = "Terraform-managed IAM users must have an aws_iam_user_group_membership resource with all groups specified by iam-user-group-membership-check-group-names."
  }
}
