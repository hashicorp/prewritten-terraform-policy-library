# Copyright IBM Corp. 2026

policytest {
  targets = ["iam-policy-in-use.policy.hcl"]
}

# PASS: AWSSupportAccess attached to a group with at least one user
resource "aws_iam_group_policy_attachment" "pass_group_with_user" {
  attrs = {
    group      = "support-group"
    policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
  }
}

resource "aws_iam_group_membership" "pass_group_with_user_membership" {
  skip = true
  attrs = {
    name  = "support-group-membership"
    group = "support-group"
    users = ["support-user"]
  }
}

# FAIL: AWSSupportAccess attached to an empty group
resource "aws_iam_group_policy_attachment" "fail_empty_group" {
  expect_failure = true
  attrs = {
    group      = "empty-support-group"
    policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
  }
}

resource "aws_iam_group_membership" "fail_empty_group_membership" {
  skip = true
  attrs = {
    name  = "empty-support-group-membership"
    group = "empty-support-group"
    users  = []
  }
}

# FAIL: AWSSupportAccess attached to a group with no membership resource
resource "aws_iam_group_policy_attachment" "fail_missing_group_membership" {
  expect_failure = true
  attrs = {
    group      = "missing-membership-group"
    policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
  }
}

# PASS: Different managed policy attached to a group
resource "aws_iam_group_policy_attachment" "pass_other_group_policy" {
  attrs = {
    group      = "other-policy-group"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
}

# PASS: AWSSupportAccess attached to a role with a trusted principal
resource "aws_iam_role" "pass_trusted_role" {
  skip = true
  attrs = {
    name = "support-role"
    assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"arn:aws:iam::123456789012:root\"},\"Action\":\"sts:AssumeRole\"}]}"
  }
}

resource "aws_iam_role_policy_attachment" "pass_trusted_role_attachment" {
  attrs = {
    role       = "support-role"
    policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
  }
}

# FAIL: Role has no Principal in its trust policy
resource "aws_iam_role" "fail_no_principal" {
  skip = true
  attrs = {
    name = "support-role-no-principal"
    assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Action\":\"sts:AssumeRole\",\"Resource\":\"*\"}]}"
  }
}

resource "aws_iam_role_policy_attachment" "fail_no_principal_attachment" {
  expect_failure = true
  attrs = {
    role       = "support-role-no-principal"
    policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
  }
}

# FAIL: Role has a Principal but no STS assume-role action
resource "aws_iam_role" "fail_no_assume_action" {
  skip = true
  attrs = {
    name = "support-role-no-assume-action"
    assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"arn:aws:iam::123456789012:root\"},\"Action\":\"iam:PassRole\"}]}"
  }
}

resource "aws_iam_role_policy_attachment" "fail_no_assume_action_attachment" {
  expect_failure = true
  attrs = {
    role       = "support-role-no-assume-action"
    policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
  }
}

# FAIL: Role does not exist in the evaluated Terraform resources
resource "aws_iam_role_policy_attachment" "fail_missing_role" {
  expect_failure = true
  attrs = {
    role       = "missing-support-role"
    policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
  }
}

# PASS: Role trusts SAML federation
resource "aws_iam_role" "pass_saml_role" {
  skip = true
  attrs = {
    name = "support-saml-role"
    assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Federated\":\"arn:aws:iam::123456789012:saml-provider/Example\"},\"Action\":\"sts:AssumeRoleWithSAML\"}]}"
  }
}

resource "aws_iam_role_policy_attachment" "pass_saml_role_attachment" {
  attrs = {
    role       = "support-saml-role"
    policy_arn = "arn:aws:iam::aws:policy/AWSSupportAccess"
  }
}

# PASS: Different managed policy attached to a role
resource "aws_iam_role" "pass_other_policy_role" {
  skip = true
  attrs = {
    name = "other-policy-role"
    assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"arn:aws:iam::123456789012:root\"},\"Action\":\"sts:AssumeRole\"}]}"
  }
}

resource "aws_iam_role_policy_attachment" "pass_other_policy_role_attachment" {
  attrs = {
    role       = "other-policy-role"
    policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
}
