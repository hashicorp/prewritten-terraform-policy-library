# Copyright IBM Corp. 2026

# Separate file: assumes inputs.resource_id = "i-d1" (scopes the policy to only
# that single instance). Isolated because it needs its own inputs {} block.

policytest {
  targets = ["ec2-backup-recovery-point-time-period.policy.hcl"]
}

inputs {
  ec2-backup-recovery-point-time-period-resource_id = "i-d1"
}

# FAIL: id matches resource_id, so it is in scope and has no backup coverage.
resource "aws_instance" "fail_in_scope_no_coverage" {
  expect_failure = true
  attrs = {
    ami               = "ami-12345678"
    id                = "i-d1"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-d1"
  }
}

# PASS (trivially, via filter): id does not match resource_id, so this instance is out
# of scope and is never evaluated, even though it also has no backup coverage.
resource "aws_instance" "pass_out_of_scope_by_id" {
  attrs = {
    ami               = "ami-12345678"
    id                = "i-d2"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-d2"
  }
}
