# Copyright IBM Corp. 2026

policytest {
    targets = [
        "workspaces-user-volume-encryption-enabled.policy.hcl"
    ]
}

# Test 1: PASS - User volume encryption is enabled
resource "aws_workspaces_workspace" "pass_user_volume_encrypted" {
  attrs = {
    user_volume_encryption_enabled  = true
  }
}

# Test 2: FAIL - User volume encryption is disabled
resource "aws_workspaces_workspace" "fail_user_volume_not_encrypted" {
  expect_failure = true
  attrs = {
    user_volume_encryption_enabled  = false
  }
}

# Test 3: FAIL - user_volume_encryption_enabled omitted entirely, which defaults to false.
# directory_id is present only so attrs is non-empty; it is not part of the control.
resource "aws_workspaces_workspace" "fail_user_volume_missing_encryption" {
  expect_failure = true
  attrs = {
    directory_id = null
  }
}
