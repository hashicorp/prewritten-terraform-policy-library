# Copyright IBM Corp. 2026

# Ensure access keys are not setup during initial user setup for all users that have a console password

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "iam-user-console-and-api-access-at-creation-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_iam_user_login_profile" "prevent_console_and_api_access_at_creation" {

  locals {
    username_raw = core::try(attrs.user, null)
    username = local.username_raw != null ? local.username_raw : ""
    matching_access_keys = local.username != "" ? core::getresources("aws_iam_access_key", {
      user = local.username
    }) : []
    is_compliant = local.username == "" || core::length(local.matching_access_keys) == 0
  }

  enforcement_level = input.iam-user-console-and-api-access-at-creation-enforcement-level
  enforce {
    condition     = local.is_compliant
    error_message = "Do not create an IAM login profile and access key for the same user. Remove the planned aws_iam_access_key or aws_iam_user_login_profile resource."
  }
}
