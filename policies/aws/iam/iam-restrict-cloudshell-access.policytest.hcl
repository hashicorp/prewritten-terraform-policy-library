policytest {
  targets = ["iam-restrict-cloudshell-access.policy.hcl"]
}

resource "aws_iam_user_policy_attachment" "pass_other_managed_policy" {
  attrs = {
    user       = "validation-user"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
}

resource "aws_iam_user_policy_attachment" "fail_cloudshell_full_access" {
  expect_failure = true
  attrs = {
    user       = "validation-user"
    policy_arn = "arn:aws:iam::aws:policy/AWSCloudShellFullAccess"
  }
}

resource "aws_iam_group_policy_attachment" "pass_other_managed_policy" {
  attrs = {
    group      = "validation-group"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
}

resource "aws_iam_group_policy_attachment" "fail_cloudshell_full_access" {
  expect_failure = true
  attrs = {
    group      = "validation-group"
    policy_arn = "arn:aws:iam::aws:policy/AWSCloudShellFullAccess"
  }
}

resource "aws_iam_role_policy_attachment" "pass_other_managed_policy" {
  attrs = {
    role       = "validation-role"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
}

resource "aws_iam_role_policy_attachment" "fail_cloudshell_full_access" {
  expect_failure = true
  attrs = {
    role       = "validation-role"
    policy_arn = "arn:aws:iam::aws:policy/AWSCloudShellFullAccess"
  }
}

resource "aws_iam_user_policy" "pass_specific_scalar_action" {
  attrs = {
    name   = "specific-cloudshell-action"
    user   = "validation-user"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":\"cloudshell:CreateEnvironment\",\"Resource\":\"*\"}]}"
  }
}

resource "aws_iam_user_policy" "fail_scalar_cloudshell_wildcard" {
  expect_failure = true
  attrs = {
    name   = "full-cloudshell-access"
    user   = "validation-user"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":\"cloudshell:*\",\"Resource\":\"*\"}]}"
  }
}

resource "aws_iam_group_policy" "pass_deny_cloudshell_wildcard" {
  attrs = {
    name   = "deny-cloudshell-access"
    group  = "validation-group"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Deny\",\"Action\":\"cloudshell:*\",\"Resource\":\"*\"}]}"
  }
}

resource "aws_iam_group_policy" "fail_case_variant_list_wildcard" {
  expect_failure = true
  attrs = {
    name   = "full-cloudshell-access"
    group  = "validation-group"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"ec2:DescribeInstances\",\"CloudShell:*\"],\"Resource\":\"*\"}]}"
  }
}

resource "aws_iam_role_policy" "pass_specific_action_list" {
  attrs = {
    name   = "specific-cloudshell-actions"
    role   = "validation-role"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"cloudshell:CreateEnvironment\",\"cloudshell:CreateSession\"],\"Resource\":\"*\"}]}"
  }
}

resource "aws_iam_role_policy" "fail_list_cloudshell_wildcard" {
  expect_failure = true
  attrs = {
    name   = "full-cloudshell-access"
    role   = "validation-role"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":[\"cloudshell:CreateSession\",\"cloudshell:*\"],\"Resource\":\"*\"}]}"
  }
}
