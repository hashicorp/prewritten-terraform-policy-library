# Copyright IBM Corp. 2026

policytest {
    targets = [
        "ec2-ebs-encryption-by-default.policy.hcl"
    ]
}

# Test 1: PASS - Resource with enabled = true
resource "aws_ebs_encryption_by_default" "enabled_true" {
  attrs = {
    enabled = true
  }
}

# Test 2: FAIL - Resource with enabled = false
resource "aws_ebs_encryption_by_default" "enabled_false" {
  expect_failure = true
  attrs = {
    enabled = false
  }
}

# Test 3: PASS - 'enabled' unset. A missing attribute resolves to null, which the
# policy coalesces to the provider default of true, so this passes.
resource "aws_ebs_encryption_by_default" "pass_enabled_unset" {
  attrs = {
    enabled = null
  }
}
