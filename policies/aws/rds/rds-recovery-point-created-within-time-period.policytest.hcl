# Copyright IBM Corp. 2026

policytest {
  targets = ["rds-recovery-point-created-within-time-period.policy.hcl"]
}

# Shared companion resources (aws_iam_role / aws_backup_plan / aws_backup_selection)
# used across the pass/fail scenarios below. All companion resources are marked
# skip = true because this policy only targets aws_db_instance / aws_rds_cluster;
# they are visible to core::getresources() but must not be evaluated directly.

resource "aws_iam_role" "backup_role" {
  skip = true
  attrs = {
    name                = "backup-role"
    arn                 = "arn:aws:iam::123456789012:role/backup-role"
    assume_role_policy   = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"backup.amazonaws.com\"}}]}"
    path                = "/"
    tags                = {}
  }
}

resource "aws_backup_plan" "main_plan" {
  skip = true
  attrs = {
    name = "main-backup-plan"
    id   = "plan-1234"
    tags = {}
  }
}

# Valid selection: links to main_plan + backup_role, selects RDS instances by ARN.
resource "aws_backup_selection" "sel_arn" {
  skip = true
  attrs = {
    name         = "sel-arn"
    plan_id      = "plan-1234"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources = [
      "arn:aws:rds:us-east-1:123456789012:db:compliant-db",
      "arn:aws:rds:us-east-1:123456789012:db:no-retention-db",
    ]
    selection_tag = []
  }
}

# Scenario 1: PASS - backup_retention_period > 0 and referenced by ARN in a valid selection.
resource "aws_db_instance" "compliant_db" {
  attrs = {
    identifier              = "compliant-db"
    arn                     = "arn:aws:rds:us-east-1:123456789012:db:compliant-db"
    backup_retention_period = 7
    backup_window           = "09:46-10:16"
    tags                    = {}
  }
}

# Scenario 2: FAIL - backup_retention_period = 0 even though referenced in a valid selection.
resource "aws_db_instance" "no_retention_db" {
  expect_failure = true
  attrs = {
    identifier              = "no-retention-db"
    arn                     = "arn:aws:rds:us-east-1:123456789012:db:no-retention-db"
    backup_retention_period = 0
    backup_window           = "09:46-10:16"
    tags                    = {}
  }
}

# Scenario 3: FAIL - not referenced by any backup selection (ARN or tag).
resource "aws_db_instance" "unlinked_db" {
  expect_failure = true
  attrs = {
    identifier              = "unlinked-db"
    arn                     = "arn:aws:rds:us-east-1:123456789012:db:unlinked-db"
    backup_retention_period = 7
    backup_window           = "09:46-10:16"
    tags                    = {}
  }
}

# Tag-based valid selection: links to main_plan + backup_role, selects by tag conditions.
resource "aws_backup_selection" "sel_tag" {
  skip = true
  attrs = {
    name         = "sel-tag"
    plan_id      = "plan-1234"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources    = []
    selection_tag = [
      {
        key   = "Backup"
        type  = "STRINGEQUALS"
        value = "true"
      },
      {
        key   = "Environment"
        type  = "STRINGEQUALS"
        value = "prod"
      },
    ]
  }
}

# Scenario 4: PASS - tags satisfy ALL selection_tag conditions.
resource "aws_db_instance" "tag_match_db" {
  attrs = {
    identifier              = "tag-match-db"
    arn                     = "arn:aws:rds:us-east-1:123456789012:db:tag-match-db"
    backup_retention_period = 7
    backup_window           = "09:46-10:16"
    tags = {
      Backup      = "true"
      Environment = "prod"
    }
  }
}

# Scenario 5: FAIL - only one of the two selection_tag conditions matches.
resource "aws_db_instance" "partial_tag_db" {
  expect_failure = true
  attrs = {
    identifier              = "partial-tag-db"
    arn                     = "arn:aws:rds:us-east-1:123456789012:db:partial-tag-db"
    backup_retention_period = 7
    backup_window           = "09:46-10:16"
    tags = {
      Backup      = "true"
      Environment = "dev"
    }
  }
}

# NOTE: Scenario 6 (wildcard ARN match) lives in its own file
# (rds-recovery-point-created-within-time-period-5.policytest.hcl) because a
# selection with a wildcard "resources" entry (ending in ":*") matches EVERY
# aws_db_instance / aws_rds_cluster in the same test file once that selection is
# valid, which would corrupt the "not in any backup selection" fail scenarios
# below (unlinked_db, partial_tag_db, bad_plan_db, bad_role_db, unlinked_cluster).

# Invalid selection: plan_id does not match any aws_backup_plan in the plan.
resource "aws_backup_selection" "sel_bad_plan" {
  skip = true
  attrs = {
    name          = "sel-bad-plan"
    plan_id       = "nonexistent-plan-id"
    iam_role_arn  = "arn:aws:iam::123456789012:role/backup-role"
    resources     = ["arn:aws:rds:us-east-1:123456789012:db:bad-plan-db"]
    selection_tag = []
  }
}

# Scenario 7: FAIL - the referencing selection has an unresolved plan_id dependency.
resource "aws_db_instance" "bad_plan_db" {
  expect_failure = true
  attrs = {
    identifier              = "bad-plan-db"
    arn                     = "arn:aws:rds:us-east-1:123456789012:db:bad-plan-db"
    backup_retention_period = 7
    backup_window           = "09:46-10:16"
    tags                    = {}
  }
}

# Invalid selection: iam_role_arn does not match any aws_iam_role in the plan.
resource "aws_backup_selection" "sel_bad_role" {
  skip = true
  attrs = {
    name          = "sel-bad-role"
    plan_id       = "plan-1234"
    iam_role_arn  = "arn:aws:iam::123456789012:role/nonexistent-role"
    resources     = ["arn:aws:rds:us-east-1:123456789012:db:bad-role-db"]
    selection_tag = []
  }
}

# Scenario 8: FAIL - the referencing selection has an unresolved iam_role_arn dependency.
resource "aws_db_instance" "bad_role_db" {
  expect_failure = true
  attrs = {
    identifier              = "bad-role-db"
    arn                     = "arn:aws:rds:us-east-1:123456789012:db:bad-role-db"
    backup_retention_period = 7
    backup_window           = "09:46-10:16"
    tags                    = {}
  }
}

# Valid selection covering aws_rds_cluster resources by ARN.
resource "aws_backup_selection" "sel_cluster" {
  skip = true
  attrs = {
    name         = "sel-cluster"
    plan_id      = "plan-1234"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources = [
      "arn:aws:rds:us-east-1:123456789012:cluster:compliant-cluster",
      "arn:aws:rds:us-east-1:123456789012:cluster:no-retention-cluster",
    ]
    selection_tag = []
  }
}

# Scenario 10: PASS - cluster referenced by ARN in a valid selection.
resource "aws_rds_cluster" "compliant_cluster" {
  attrs = {
    cluster_identifier       = "compliant-cluster"
    arn                      = "arn:aws:rds:us-east-1:123456789012:cluster:compliant-cluster"
    backup_retention_period  = 7
    preferred_backup_window  = "09:46-10:16"
    tags                     = {}
  }
}

# Scenario 11: FAIL - backup_retention_period = 0 even though referenced in a valid selection.
resource "aws_rds_cluster" "no_retention_cluster" {
  expect_failure = true
  attrs = {
    cluster_identifier       = "no-retention-cluster"
    arn                      = "arn:aws:rds:us-east-1:123456789012:cluster:no-retention-cluster"
    backup_retention_period  = 0
    preferred_backup_window  = "09:46-10:16"
    tags                     = {}
  }
}

# Scenario 12: FAIL - cluster not referenced by any backup selection.
resource "aws_rds_cluster" "unlinked_cluster" {
  expect_failure = true
  attrs = {
    cluster_identifier       = "unlinked-cluster"
    arn                      = "arn:aws:rds:us-east-1:123456789012:cluster:unlinked-cluster"
    backup_retention_period  = 7
    preferred_backup_window  = "09:46-10:16"
    tags                     = {}
  }
}
