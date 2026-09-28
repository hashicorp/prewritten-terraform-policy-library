# Copyright IBM Corp. 2026

policytest {
  targets = ["iam-user-group-membership-check.policy.hcl"]
}

# PASS: alice has a membership with a non-empty groups list — compliant.
resource "aws_iam_user_group_membership" "alice_membership" {
  skip = true
  attrs = {
    user   = "alice"
    groups = ["administrators"]
  }
}

# Supporting membership for eve (different user, not used by any aws_iam_user test below).
resource "aws_iam_user_group_membership" "different_user_membership" {
  skip = true
  attrs = {
    user   = "eve"
    groups = ["operators"]
  }
}

# Supporting membership for charlie with an empty groups list.
resource "aws_iam_user_group_membership" "empty_membership" {
  skip = true
  attrs = {
    user   = "charlie"
    groups = []
  }
}

# PASS: dana's membership is declared from the group side via aws_iam_group_membership.
resource "aws_iam_group_membership" "group_side_membership" {
  skip = true
  attrs = {
    name  = "developers-membership"
    group = "developers"
    users = ["dana", "erin"]
  }
}

# Supporting group-side membership with no users — does not satisfy any user.
resource "aws_iam_group_membership" "group_side_empty" {
  skip = true
  attrs = {
    name  = "empty-membership"
    group = "empty-group"
    users = []
  }
}

# PASS: User whose name matches a membership resource that has a non-empty groups list.
resource "aws_iam_user" "matching_nonempty_membership" {
  attrs = {
    name = "alice"
  }
}

# PASS: User whose membership is declared group-side via aws_iam_group_membership.
resource "aws_iam_user" "group_side_membership_user" {
  attrs = {
    name = "dana"
  }
}

# FAIL: User with no aws_iam_user_group_membership resource at all — violates CIS 1.15.
resource "aws_iam_user" "missing_membership" {
  expect_failure = true
  attrs = {
    name = "bob"
  }
}

# FAIL: User whose membership resource exists but has an empty groups list — violates CIS 1.15.
resource "aws_iam_user" "membership_with_empty_groups" {
  expect_failure = true
  attrs = {
    name = "charlie"
  }
}

# FAIL: User with a null name attribute — user_name resolves to "" so condition fails.
resource "aws_iam_user" "null_name" {
  expect_failure = true
  attrs = {
    name = null
  }
}
