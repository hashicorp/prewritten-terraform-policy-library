# Copyright IBM Corp. 2026

# Separate file: assumes inputs.resource_tags = "{\"Environment\":\"prod\"}"
# (see testcase_gen.md 4.2 case 1 -- distinct inputs{} values from other
# files).
policytest {
  targets = ["ebs-backup-recovery-point-created.policy.hcl"]
}

inputs {
  ebs-backup-recovery-point-created-resource_tags = "{\"Environment\":\"prod\"}"
}

# Scenario 14: resource_tags filter is set, and this volume's tags do NOT
# include Environment=prod -> the volume is skipped (filtered out) -> PASS
# since it is out of scope
resource "aws_ebs_volume" "tags_mismatch_skipped_pass" {
  attrs = {
    id                = "vol-eee14"
    availability_zone = "us-east-1a"
    tags = {
      Environment = "dev"
    }
  }
}

# Scenario 15: resource_tags filter is set, this volume's tags include
# Environment=prod, and it has no compliant backup coverage -> FAIL
resource "aws_ebs_volume" "tags_match_no_coverage_fail" {
  expect_failure = true
  attrs = {
    id                = "vol-eee15"
    availability_zone = "us-east-1a"
    tags = {
      Environment = "prod"
    }
  }
}
