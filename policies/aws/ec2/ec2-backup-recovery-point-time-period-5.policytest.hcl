# Copyright IBM Corp. 2026

# Separate file: assumes inputs.resource_tags = "{\"Environment\":\"production\"}"
# (scopes the policy to instances whose Environment tag equals "production"). Isolated
# because it needs its own inputs {} block.

policytest {
  targets = ["ec2-backup-recovery-point-time-period.policy.hcl"]
}

inputs {
  ec2-backup-recovery-point-time-period-resource_tags = "{\"Environment\":\"production\"}"
}

# FAIL: Environment=production matches the resourceTags filter, so it is in scope
# and has no backup coverage.
resource "aws_instance" "fail_in_scope_by_tag" {
  expect_failure = true
  attrs = {
    ami               = "ami-12345678"
    id                = "i-e1"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-e1"
    tags = {
      Environment = "production"
    }
  }
}

# PASS (trivially, via filter): Environment=staging does not match the resourceTags
# filter, so this instance is out of scope and is never evaluated, even though it also
# has no backup coverage.
resource "aws_instance" "pass_out_of_scope_by_tag" {
  attrs = {
    ami               = "ami-12345678"
    id                = "i-e2"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-e2"
    tags = {
      Environment = "staging"
    }
  }
}
