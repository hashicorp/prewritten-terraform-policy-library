# Copyright IBM Corp. 2026

policytest {
  targets = ["iam-managed-policy-should-be-attached-to-role.policy.hcl"]
}

inputs {
  iam-managed-policy-should-be-attached-to-role-managed_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    "arn:aws:iam::aws:policy/SecurityAudit",
  ]
}

# PASS: both required policies attached with aws_iam_role_policy_attachment.
resource "aws_iam_role" "pass_role_policy_attachments" {
  attrs = {
    name               = "role-attachments"
    assume_role_policy = "{}"
  }
}

resource "aws_iam_role_policy_attachment" "attach_readonly" {
  skip = true
  attrs = {
    role       = "role-attachments"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
}

resource "aws_iam_role_policy_attachment" "attach_audit" {
  skip = true
  attrs = {
    role       = "role-attachments"
    policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
  }
}

# FAIL: only one of the two required policies is attached.
resource "aws_iam_role" "fail_one_policy_missing" {
  expect_failure = true
  attrs = {
    name               = "role-partial"
    assume_role_policy = "{}"
  }
}

resource "aws_iam_role_policy_attachment" "attach_partial" {
  skip = true
  attrs = {
    role       = "role-partial"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
}

# FAIL: no policies attached.
resource "aws_iam_role" "fail_no_attachments" {
  expect_failure = true
  attrs = {
    name               = "role-none"
    assume_role_policy = "{}"
  }
}

# FAIL: required policies attached to a different role only.
resource "aws_iam_role" "fail_attached_to_other_role" {
  expect_failure = true
  attrs = {
    name               = "role-other"
    assume_role_policy = "{}"
  }
}

resource "aws_iam_policy_attachment" "attach_to_unrelated_role" {
  skip = true
  attrs = {
    name       = "attach-unrelated"
    roles      = ["unrelated-role"]
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
}

# PASS: required policies set through the role's managed_policy_arns attribute.
resource "aws_iam_role" "pass_managed_policy_arns" {
  attrs = {
    name               = "role-inline-arns"
    assume_role_policy = "{}"
    managed_policy_arns = [
      "arn:aws:iam::aws:policy/ReadOnlyAccess",
      "arn:aws:iam::aws:policy/SecurityAudit",
    ]
  }
}

# PASS: one policy from aws_iam_policy_attachment (roles list), one from
# aws_iam_role_policy_attachment.
resource "aws_iam_role" "pass_policy_attachment_roles" {
  attrs = {
    name               = "role-mixed"
    assume_role_policy = "{}"
  }
}

resource "aws_iam_policy_attachment" "attach_readonly_many" {
  skip = true
  attrs = {
    name       = "readonly-many"
    roles      = ["role-mixed", "some-other-role"]
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
}

resource "aws_iam_role_policy_attachment" "attach_audit_mixed" {
  skip = true
  attrs = {
    role       = "role-mixed"
    policy_arn = "arn:aws:iam::aws:policy/SecurityAudit"
  }
}

# PASS: role name with mixed case still matches its attachments exactly.
resource "aws_iam_role" "pass_mixed_case_name" {
  attrs = {
    name               = "Role-MixedCase"
    assume_role_policy = "{}"
    managed_policy_arns = [
      "arn:aws:iam::aws:policy/ReadOnlyAccess",
      "arn:aws:iam::aws:policy/SecurityAudit",
    ]
  }
}
