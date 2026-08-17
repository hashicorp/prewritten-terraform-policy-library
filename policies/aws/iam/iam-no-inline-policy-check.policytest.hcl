policytest {
  targets = ["iam-no-inline-policy-check.policy.hcl"]
}

# PASS: a managed IAM policy is not an inline user, group, or role policy.
resource "aws_iam_policy" "pass_no_inline_policies" {
  attrs = {
    name   = "validation-managed-policy"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

# FAIL: required attributes are present while the optional name is omitted.
resource "aws_iam_user_policy" "fail_user_inline_policy_missing_optional_name" {
  expect_failure = true
  attrs = {
    user   = "validation-user"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

resource "aws_iam_group_policy" "fail_group_inline_policy" {
  expect_failure = true
  attrs = {
    name   = "validation-group-inline-policy"
    group  = "validation-group"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

resource "aws_iam_role_policy" "fail_role_inline_policy" {
  expect_failure = true
  attrs = {
    name   = "validation-role-inline-policy"
    role   = "validation-role"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}
