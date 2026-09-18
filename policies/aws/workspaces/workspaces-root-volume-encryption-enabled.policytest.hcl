# Copyright IBM Corp. 2026

policytest {
    targets = [
        "workspaces-root-volume-encryption-enabled.policy.hcl"
    ]
}

# Test 1: PASS - Root volume encryption is enabled
resource "aws_workspaces_workspace" "pass_root_volume_encrypted" {
  attrs = {
    root_volume_encryption_enabled  = true
  }
}

# Test 2: FAIL - Root volume encryption is disabled
resource "aws_workspaces_workspace" "fail_root_volume_not_encrypted" {
  expect_failure = true
  attrs = {
    root_volume_encryption_enabled  = false
  }
}

# Test 3: FAIL - root_volume_encryption_enabled omitted entirely, which defaults to false.
# directory_id is present only so attrs is non-empty; it is not part of the control.
resource "aws_workspaces_workspace" "fail_root_volume_missing_encryption" {
  expect_failure = true
  attrs = {
    directory_id = null
  }
}

