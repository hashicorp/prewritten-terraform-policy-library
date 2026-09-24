# Copyright IBM Corp. 2026

# Ensure there is only one active access key available for any single user

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "iam-user-single-access-key-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_iam_user" "single_active_access_key_per_user" {

  locals {
    user_name = core::try(attrs.name, "")

    iam_access_keys = local.user_name != "" ? core::getdatasource("aws_iam_access_keys", {
      user = local.user_name
    }) : null

    all_keys = local.iam_access_keys != null ? core::try(local.iam_access_keys.access_keys, []) : []

    active_keys = [
      for k in local.all_keys : k
      if core::try(k.status, "") == "Active"
    ]

    is_compliant = local.user_name != "" && core::length(local.active_keys) <= 1
  }

  enforcement_level = input.iam-user-single-access-key-enforcement-level
  enforce {
    condition     = local.is_compliant
    error_message = "IAM user '${local.user_name}' has ${core::length(local.active_keys)} active access key(s). Ensure no more than one active access key exists per user."
  }
}
