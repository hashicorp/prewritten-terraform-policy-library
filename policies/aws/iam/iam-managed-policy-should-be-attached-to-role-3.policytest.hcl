# Copyright IBM Corp. 2026

policytest {
  targets = ["iam-managed-policy-should-be-attached-to-role.policy.hcl"]
}

# Separate file: assumes inputs.managed_policy_arns =
# ["arn:aws:iam::aws:policy/ReadOnlyAccess", "arn:aws:iam::aws:policy/AdministratorAccess"]
# (two required managed policy ARNs). Exercises the "ALL required policies
# must be attached" logic, not just "any one of them".
inputs {
  iam-managed-policy-should-be-attached-to-role-managed_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]
}

# PASS: role has both required managed policies attached.
resource "aws_iam_role" "pass_role_with_both_required_policies" {
  attrs = {
    name                = "role-pass-both"
    assume_role_policy  = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

resource "aws_iam_role_policy_attachment" "pass_role_with_both_required_policies_a" {
  skip = true
  attrs = {
    role       = "role-pass-both"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
}

resource "aws_iam_role_policy_attachment" "pass_role_with_both_required_policies_b" {
  skip = true
  attrs = {
    role       = "role-pass-both"
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  }
}

# FAIL: role has only ONE of the two required managed policies attached.
resource "aws_iam_role" "fail_role_with_only_one_required_policy" {
  expect_failure = true
  attrs = {
    name                = "role-fail-partial"
    assume_role_policy  = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

resource "aws_iam_role_policy_attachment" "fail_role_with_only_one_required_policy_attachment" {
  skip = true
  attrs = {
    role       = "role-fail-partial"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
}
