# Copyright IBM Corp. 2026

# Separate file: isolates the wildcard-ARN-match scenario (sel_wildcard's
# "resources" entry ends in ":*", which would match EVERY aws_db_instance /
# aws_rds_cluster declared in the same test file - see Test File Rules case 2 and
# the note in the main test file). Uses the policy's default inputs
# (resource_id = "", resource_tags = {}).

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

# Wildcard valid selection: resources list contains a trailing ":*" pattern.
resource "aws_backup_selection" "sel_wildcard" {
  skip = true
  attrs = {
    name          = "sel-wildcard"
    plan_id       = "plan-1234"
    iam_role_arn  = "arn:aws:iam::123456789012:role/backup-role"
    resources     = ["arn:aws:rds:*:*:db:*"]
    selection_tag = []
  }
}

# Scenario 6: PASS - matched via wildcard resources entry.
resource "aws_db_instance" "wildcard_db" {
  attrs = {
    identifier              = "wildcard-db"
    arn                     = "arn:aws:rds:us-east-1:123456789012:db:wildcard-db"
    backup_retention_period = 7
    backup_window           = "09:46-10:16"
    tags                    = {}
  }
}
