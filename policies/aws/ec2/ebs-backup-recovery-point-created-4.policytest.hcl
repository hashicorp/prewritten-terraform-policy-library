# Copyright IBM Corp. 2026

# Separate file: assumes inputs.resource_id = "vol-ddd-match" (see
# testcase_gen.md 4.2 case 1 -- distinct inputs{} values from other files).
policytest {
  targets = ["ebs-backup-recovery-point-created.policy.hcl"]
}

inputs {
  ebs-backup-recovery-point-created-resource_id = "vol-ddd-match"
}

# Scenario 12: resource_id input set to a specific volume's id; a DIFFERENT
# volume (non-matching id, no backup coverage) is skipped (filtered out) ->
# PASS for that resource since it was never in scope for evaluation
resource "aws_ebs_volume" "non_matching_id_skipped_pass" {
  attrs = {
    id                = "vol-ddd-other"
    arn               = "arn:aws:ec2:us-east-1:123456789012:volume/vol-ddd-other"
    availability_zone = "us-east-1a"
  }
}

# Scenario 13: resource_id input matches this volume's id, and it is not
# covered by any compliant backup selection -> FAIL
resource "aws_ebs_volume" "matching_id_no_coverage_fail" {
  expect_failure = true
  attrs = {
    id                = "vol-ddd-match"
    arn               = "arn:aws:ec2:us-east-1:123456789012:volume/vol-ddd-match"
    availability_zone = "us-east-1a"
  }
}
