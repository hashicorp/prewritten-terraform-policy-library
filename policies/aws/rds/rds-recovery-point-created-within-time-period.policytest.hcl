# Copyright IBM Corp. 2026

policytest {
  targets = ["rds-recovery-point-created-within-time-period.policy.hcl"]
}

resource "aws_iam_role" "backup_role" {
  skip = true
  attrs = {
    name               = "backup-role"
    arn                = "arn:aws:iam::123456789012:role/backup-role"
    assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"backup.amazonaws.com\"}}]}"
    path               = "/"
    tags               = {}
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

# PASS: backup_retention_period > 0 and referenced by ARN in a valid selection
resource "aws_db_instance" "compliant_db" {
  attrs = {
    identifier              = "compliant-db"
    arn                     = "arn:aws:rds:us-east-1:123456789012:db:compliant-db"
    backup_retention_period = 7
    backup_window           = "09:46-10:16"
    tags                    = {}
  }
}

# FAIL: backup_retention_period = 0 even though referenced in a valid selection
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

# FAIL: not referenced by any backup selection (ARN or tag)
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

# PASS: tags satisfy ALL selection_tag conditions
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

# FAIL: only one of the two selection_tag conditions matches
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

# FAIL: the referencing selection has an unresolved plan_id dependency
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

# FAIL: the referencing selection has an unresolved iam_role_arn dependency
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

# PASS: cluster referenced by ARN in a valid selection
resource "aws_rds_cluster" "compliant_cluster" {
  attrs = {
    cluster_identifier      = "compliant-cluster"
    arn                     = "arn:aws:rds:us-east-1:123456789012:cluster:compliant-cluster"
    backup_retention_period = 7
    preferred_backup_window = "09:46-10:16"
    tags                    = {}
  }
}

# FAIL: backup_retention_period = 0 even though referenced in a valid selection
resource "aws_rds_cluster" "no_retention_cluster" {
  expect_failure = true
  attrs = {
    cluster_identifier      = "no-retention-cluster"
    arn                     = "arn:aws:rds:us-east-1:123456789012:cluster:no-retention-cluster"
    backup_retention_period = 0
    preferred_backup_window = "09:46-10:16"
    tags                    = {}
  }
}

# FAIL: cluster not referenced by any backup selection
resource "aws_rds_cluster" "unlinked_cluster" {
  expect_failure = true
  attrs = {
    cluster_identifier      = "unlinked-cluster"
    arn                     = "arn:aws:rds:us-east-1:123456789012:cluster:unlinked-cluster"
    backup_retention_period = 7
    preferred_backup_window = "09:46-10:16"
    tags                    = {}
  }
}

# FAIL: no selection at all db
resource "aws_db_instance" "no_selection_at_all_db_f2" {
  expect_failure = true
  attrs = {
    identifier              = "no-selection-at-all-db"
    arn                     = "arn:aws:rds:us-east-1:123456789012:db:no-selection-at-all-db"
    backup_retention_period = 7
    backup_window           = "09:46-10:16"
    tags                    = {}
  }
}
