# Copyright IBM Corp. 2026

# Separate file: no aws_backup_selection / aws_backup_plan / aws_iam_role resources
# are declared anywhere in this file, so core::getresources("aws_backup_selection", {})
# must return []. This cannot be combined with the main test file, which declares
# aws_backup_selection resources for other scenarios (see Test File Rules case 2 -
# a scenario needs core::getresources() to return zero results for a resource type
# that another scenario defines). Uses the policy's default inputs (resource_id = "",
# resource_tags = {}).

policytest {
  targets = ["rds-recovery-point-created-within-time-period.policy.hcl"]
}

# Scenario 9: FAIL - no AWS Backup selections exist in the plan at all, so the
# resource cannot be included in any backup selection, regardless of its own
# backup_retention_period setting.
resource "aws_db_instance" "no_selection_at_all_db" {
  expect_failure = true
  attrs = {
    identifier              = "no-selection-at-all-db"
    arn                     = "arn:aws:rds:us-east-1:123456789012:db:no-selection-at-all-db"
    backup_retention_period = 7
    backup_window           = "09:46-10:16"
    tags                    = {}
  }
}
