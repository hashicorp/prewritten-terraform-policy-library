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

# Converted from Sentinel policy: iam-managed-policy-should-be-attached-to-role.sentinel
#
# NOTE: This policy contains a cross-resource reference (aws_iam_role ->
# aws_iam_role_policy_attachment, linked by role name) that will not resolve
# during plan time for role names that are not yet known (e.g. auto-generated
# names on a brand new role in the same plan), but will resolve correctly
# during apply time.
#
# NOTE: `managedPolicyArns` was a comma-separated string parameter in the
# Sentinel source. It is converted to a native `list(string)` input here,
# which is the idiomatic tfpolicy equivalent and avoids re-implementing CSV
# parsing. When the list is empty (not configured), no managed policies are
# required and every IAM role is compliant - matching the Sentinel behavior
# where an empty `managedPolicyArns` parameter results in zero violations.
input "iam-managed-policy-should-be-attached-to-role-managed_policy_arns" {
  type    = list(string)
  default = []
}

resource_policy "aws_iam_role" "managed_policy_should_be_attached" {
  # Skip evaluation entirely when no managed policies are required, matching
  # the Sentinel behavior of returning zero violations in that case.
  filter = core::length(input.iam-managed-policy-should-be-attached-to-role-managed_policy_arns) > 0

  locals {
    role_name = core::try(attrs.name, "")

    # Inline lookup: filter value (role_name) is derived from this resource's
    # own attrs, so core::getresources() must be called inline here rather
    # than cached at the top level.
    attachments = core::getresources("aws_iam_role_policy_attachment", {
      role = local.role_name
    })

    attached_policy_arns = [for a in local.attachments : core::try(a.policy_arn, "")]

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
