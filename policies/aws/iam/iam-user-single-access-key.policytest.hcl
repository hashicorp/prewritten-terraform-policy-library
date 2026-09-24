# Copyright IBM Corp. 2026

policytest {
  targets = ["iam-user-single-access-key.policy.hcl"]
}

# PASS: User with exactly one Active access key — compliant.
resource "aws_iam_user" "single_active_key_user" {
  attrs = {
    name = "single-active-key-user"
  }
}

data "aws_iam_access_keys" "single_active_key_user" {
  attrs = {
    user = "single-active-key-user"
    access_keys = [
      {
        access_key_id = "AKIAIOSFODNN7EXAMPLE"
        status        = "Active"
        create_date   = "2024-01-01T00:00:00Z"
        username      = "single-active-key-user"
      }
    ]
  }
}

# PASS: User with one Active and one Inactive key — only one active key, compliant.
resource "aws_iam_user" "mixed_status_user" {
  attrs = {
    name = "mixed-status-user"
  }
}

data "aws_iam_access_keys" "mixed_status_user" {
  attrs = {
    user = "mixed-status-user"
    access_keys = [
      {
        access_key_id = "AKIAIOSFODNN7EXAMP01"
        status        = "Active"
        create_date   = "2024-01-01T00:00:00Z"
        username      = "mixed-status-user"
      },
      {
        access_key_id = "AKIAIOSFODNN7EXAMP02"
        status        = "Inactive"
        create_date   = "2023-01-01T00:00:00Z"
        username      = "mixed-status-user"
      }
    ]
  }
}

# PASS: User with no access keys — zero active keys, compliant.
resource "aws_iam_user" "no_keys_user" {
  attrs = {
    name = "no-keys-user"
  }
}

data "aws_iam_access_keys" "no_keys_user" {
  attrs = {
    user        = "no-keys-user"
    access_keys = []
  }
}

# FAIL: User with two Active access keys — violates CIS 1.13.
resource "aws_iam_user" "two_active_keys_user" {
  expect_failure = true
  attrs = {
    name = "two-active-keys-user"
  }
}

data "aws_iam_access_keys" "two_active_keys_user" {
  attrs = {
    user = "two-active-keys-user"
    access_keys = [
      {
        access_key_id = "AKIAIOSFODNN7EXAMP03"
        status        = "Active"
        create_date   = "2024-01-01T00:00:00Z"
        username      = "two-active-keys-user"
      },
      {
        access_key_id = "AKIAIOSFODNN7EXAMP04"
        status        = "Active"
        create_date   = "2024-06-01T00:00:00Z"
        username      = "two-active-keys-user"
      }
    ]
  }
}
