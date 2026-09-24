# Copyright IBM Corp. 2026

policytest {
  targets = ["iam-user-console-and-api-access-at-creation.policy.hcl"]
}

# PASS: Login profile without access key is compliant.
resource "aws_iam_user_login_profile" "pass_without_access_key" {
  attrs = {
    user = "console-only-user"
  }
}

# PASS: Login profile and access key exist, but are for different users.
resource "aws_iam_user_login_profile" "pass_with_access_key_for_different_user" {
  attrs = {
    user = "different-console-user"
  }
}

resource "aws_iam_access_key" "different_user" {
  skip = true
  attrs = {
    user = "api-only-user"
  }
}

# FAIL: Login profile and access key exist for the same user.
resource "aws_iam_user_login_profile" "fail_with_access_key_for_same_user" {
  expect_failure = true
  attrs = {
    user = "shared-user"
  }
}

resource "aws_iam_access_key" "same_user" {
  skip = true
  attrs = {
    user = "shared-user"
  }
}

# PASS: Login profile with null user attribute is compliant.
resource "aws_iam_user_login_profile" "pass_null_user" {
  attrs = {
    user = null
  }
}

# PASS: Login profile with empty user attribute is compliant.
resource "aws_iam_user_login_profile" "pass_empty_user" {
  attrs = {
    user = ""
  }
}

# PASS: Login profile with omitted user attribute is compliant.
resource "aws_iam_user_login_profile" "pass_omitted_user" {
  attrs = {}
}
