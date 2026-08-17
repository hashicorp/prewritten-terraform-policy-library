# Copyright IBM Corp. 2026

# Ensure an AWS Identity and Access Management (IAM) user, IAM role or IAM group does not have an inline policy

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

resource_policy "aws_iam_user_policy" "no_inline_policy" {
  operations = ["create", "update"]

  enforcement_level = "advisory"
  enforce {
    condition     = false
    error_message = "IAM users must use managed policies instead of inline policies. Remove this aws_iam_user_policy resource and attach an aws_iam_policy with aws_iam_user_policy_attachment."
  }
}

resource_policy "aws_iam_group_policy" "no_inline_policy" {
  operations = ["create", "update"]

  enforcement_level = "advisory"
  enforce {
    condition     = false
    error_message = "IAM groups must use managed policies instead of inline policies. Remove this aws_iam_group_policy resource and attach an aws_iam_policy with aws_iam_group_policy_attachment."
  }
}

resource_policy "aws_iam_role_policy" "no_inline_policy" {
  operations = ["create", "update"]

  enforcement_level = "advisory"
  enforce {
    condition     = false
    error_message = "IAM roles must use managed policies instead of inline policies. Remove this aws_iam_role_policy resource and attach an aws_iam_policy with aws_iam_role_policy_attachment."
  }
}
