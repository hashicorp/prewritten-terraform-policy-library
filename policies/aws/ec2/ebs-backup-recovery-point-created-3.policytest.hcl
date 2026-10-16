# Copyright IBM Corp. 2026

# Separate file: default inputs, but with NO aws_backup_plan or
# aws_backup_selection resources defined at all. core::getresources() must
# see zero results for both types here; the other files define these
# resource types, so this scenario cannot share a file with them.
policytest {
  targets = ["ebs-backup-recovery-point-created.policy.hcl"]
}

# Scenario 11: no aws_backup_selection or aws_backup_plan resources exist
# anywhere in the plan -> FAIL (volume has no backup coverage)
resource "aws_ebs_volume" "no_backup_resources_fail" {
  expect_failure = true
  attrs = {
    id                = "vol-ccc11"
    arn               = "arn:aws:ec2:us-east-1:123456789012:volume/vol-ccc11"
    availability_zone = "us-east-1a"
  }
}
