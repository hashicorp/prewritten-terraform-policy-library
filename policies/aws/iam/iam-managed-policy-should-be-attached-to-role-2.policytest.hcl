# Copyright IBM Corp. 2026

policytest {
  targets = ["iam-managed-policy-should-be-attached-to-role.policy.hcl"]
}

# Separate file: assumes inputs.managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
# (a single required managed policy ARN). Exercises the attachment-matching
# logic for roles with zero, one, or an unrelated managed policy attached.
inputs {
  iam-managed-policy-should-be-attached-to-role-managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}

# PASS: role has the exact required managed policy attached.
resource "aws_iam_role" "pass_role_with_required_policy" {
  attrs = {
    name                = "role-pass-required"
    assume_role_policy  = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

resource "aws_iam_role_policy_attachment" "pass_role_with_required_policy_attachment" {
  skip = true
  attrs = {
    role       = "role-pass-required"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
}

# FAIL: role has no aws_iam_role_policy_attachment at all - the required
# managed policy is missing.
resource "aws_iam_role" "fail_role_without_attachment" {
  expect_failure = true
  attrs = {
    name                = "role-fail-no-attachment"
    assume_role_policy  = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

# FAIL: role has an attachment, but it points to a different (non-required)
# managed policy ARN.
resource "aws_iam_role" "fail_role_with_wrong_policy" {
  expect_failure = true
  attrs = {
    name                = "role-fail-wrong-policy"
    assume_role_policy  = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

resource "aws_iam_role_policy_attachment" "fail_role_with_wrong_policy_attachment" {
  skip = true
  attrs = {
    role       = "role-fail-wrong-policy"
    policy_arn = "arn:aws:iam::aws:policy/SomeOtherPolicy"
  }
}

# PASS: role has the required managed policy attached, plus an extra,
# non-required attachment - extra attachments must not affect compliance.
resource "aws_iam_role" "pass_role_with_extra_attachment" {
  attrs = {
    name                = "role-pass-extra"
    assume_role_policy  = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

resource "aws_iam_role_policy_attachment" "pass_role_with_extra_attachment_required" {
  skip = true
  attrs = {
    role       = "role-pass-extra"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
}

resource "aws_iam_role_policy_attachment" "pass_role_with_extra_attachment_extra" {
  skip = true
  attrs = {
    role       = "role-pass-extra"
    policy_arn = "arn:aws:iam::aws:policy/SomeOtherPolicy"
  }
}

# FAIL: the required managed policy IS attached somewhere in the plan, but
# to a *different* role - attachments on other roles must not satisfy this
# role's own requirement.
resource "aws_iam_role" "fail_role_attachment_on_other_role" {
  expect_failure = true
  attrs = {
    name                = "role-fail-cross-role"
    assume_role_policy  = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}

resource "aws_iam_role_policy_attachment" "attachment_belongs_to_other_role" {
  skip = true
  attrs = {
    role       = "some-completely-different-role"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
}

# FAIL (missing-attribute edge case): role's `name` attribute is entirely
# omitted. core::try(attrs.name, "") falls back to "", which cannot match
# any attachment's `role` value, so the required policy is reported missing.
resource "aws_iam_role" "fail_role_name_omitted" {
  expect_failure = true
  attrs = {
    assume_role_policy  = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
  }
}
