# Copyright IBM Corp. 2026

# IAM roles should have the required managed policies attached

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "iam-managed-policy-should-be-attached-to-role-enforcement-level" {
  type    = string
  default = "advisory"
}

input "iam-managed-policy-should-be-attached-to-role-managed_policy_arns" {
  type    = list(string)
  default = []
}

resource_policy "aws_iam_role" "managed_policy_should_be_attached" {
  filter = core::length(input.iam-managed-policy-should-be-attached-to-role-managed_policy_arns) > 0

  locals {
    role_name = core::try(attrs.name, "")

    attachments = core::getresources("aws_iam_role_policy_attachment", {
      role = local.role_name
    })

    group_attachments = [for a in core::getresources("aws_iam_policy_attachment", {}) : a
      if core::contains(core::try(a.roles, null) == null ? [] : a.roles, local.role_name)
    ]
    inline_arns = core::try(attrs.managed_policy_arns, null) == null ? [] : attrs.managed_policy_arns
    attached_policy_arns = core::concat(
      [for a in local.attachments : core::try(a.policy_arn, "")],
      [for a in local.group_attachments : core::try(a.policy_arn, "")],
      [for a in local.inline_arns : a],
    )

    missing_policies = [
      for required_arn in input.iam-managed-policy-should-be-attached-to-role-managed_policy_arns :
      required_arn if !core::contains(local.attached_policy_arns, required_arn)
    ]
  }

  enforcement_level = input.iam-managed-policy-should-be-attached-to-role-enforcement-level
  enforce {
    condition     = core::length(local.missing_policies) == 0
    error_message = "IAM role '${local.role_name}' is missing required managed policies: ${core::join(", ", local.missing_policies)}. All required managed policies must be attached to IAM roles."
  }
}
