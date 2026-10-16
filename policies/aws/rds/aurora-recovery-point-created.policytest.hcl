# Copyright IBM Corp. 2026

policytest {
  targets = ["aurora-recovery-point-created.policy.hcl"]
}

# Default inputs file. No aws_backup_plan / aws_backup_selection resources are declared
# in this file so that core::getresources() reliably returns zero results for clusters
# that rely solely on the automated-backup path (see testing-guide.md "core::getresources()
# sees ALL resources in the test file"). Scenarios that need a compliant/non-compliant
# AWS Backup plan live in separate files (-2, -3).

# PASS: Aurora cluster with sufficient backup_retention_period, no AWS Backup plan needed.
resource "aws_rds_cluster" "pass_backup_retention_sufficient" {
  attrs = {
    cluster_identifier      = "aurora-cluster-1"
    engine                  = "aurora-mysql"
    backup_retention_period = 1
    tags                    = {}
    arn                     = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-1"
  }
}

# FAIL: Aurora cluster with backup_retention_period = 0 and no AWS Backup plan at all.
resource "aws_rds_cluster" "fail_backup_retention_insufficient_no_plan" {
  expect_failure = true
  attrs = {
    cluster_identifier      = "aurora-cluster-2"
    engine                  = "aurora-postgresql"
    backup_retention_period = 0
    tags                    = {}
    arn                     = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-2"
  }
}

# PASS (not evaluated): non-Aurora engine is excluded by the policy's filter, even
# though backup_retention_period is 0.
resource "aws_rds_cluster" "skip_non_aurora_engine" {
  attrs = {
    cluster_identifier      = "mysql-cluster-7"
    engine                  = "mysql"
    backup_retention_period = 0
    tags                    = {}
    arn                     = "arn:aws:rds:us-east-1:123456789012:cluster:mysql-cluster-7"
  }
}

# FAIL: backup_retention_period attribute entirely omitted (defaults to 0 via core::try()).
resource "aws_rds_cluster" "fail_missing_backup_retention_attribute" {
  expect_failure = true
  attrs = {
    cluster_identifier = "aurora-cluster-11"
    engine             = "aurora-mysql"
    tags               = {}
    arn                = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-11"
    # backup_retention_period intentionally omitted
  }
}

# FAIL: tags explicitly set to null (two-step normalization to {}) combined with
# insufficient backup_retention_period and no AWS Backup plan. Confirms the policy
# does not crash when tags is explicitly null.
resource "aws_rds_cluster" "fail_tags_null_no_plan" {
  expect_failure = true
  attrs = {
    cluster_identifier      = "aurora-cluster-12"
    engine                  = "aurora-mysql"
    backup_retention_period = 0
    tags                    = null
    arn                     = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-12"
  }
}

# ---- Cases merged from aurora-recovery-point-created-3.policytest.hcl ----

resource "aws_backup_plan" "plan_4_noncompliant_f3" {
  skip = true
  attrs = {
    name = "aurora-plan-4"
    rule = [{
      rule_name         = "every_two_days"
      target_vault_name = "Default"
      schedule          = "rate(2 days)"
    }]
  }
}

resource "aws_backup_plan" "plan_5_compliant_f3" {
  skip = true
  attrs = {
    name = "aurora-plan-5"
    rule = [{
      rule_name         = "daily"
      target_vault_name = "Default"
      schedule          = "rate(1 day)"
    }]
  }
}

# References cluster-4 via cluster_identifier substring match in `resources`.
resource "aws_backup_selection" "selection_4_identifier_match_f3" {
  skip = true
  attrs = {
    name          = "aurora-selection-4"
    iam_role_arn  = "arn:aws:iam::123456789012:role/aws-backup-role"
    plan_id       = "aurora-plan-4"
    resources     = ["aurora-cluster-4"]
    selection_tag = []
  }
}

# References cluster-5 via selection_tag matching the cluster's tags (STRINGEQUALS).
resource "aws_backup_selection" "selection_5_tag_match_f3" {
  skip = true
  attrs = {
    name         = "aurora-selection-5"
    iam_role_arn = "arn:aws:iam::123456789012:role/aws-backup-role"
    plan_id      = "aurora-plan-5"
    resources    = []
    selection_tag = [{
      key   = "team"
      type  = "STRINGEQUALS"
      value = "payments"
    }]
  }
}

# Does not reference cluster-6 at all (neither resources nor selection_tag match).
resource "aws_backup_selection" "selection_6_no_match_f3" {
  skip = true
  attrs = {
    name         = "aurora-selection-6"
    iam_role_arn = "arn:aws:iam::123456789012:role/aws-backup-role"
    plan_id      = "aurora-plan-4"
    resources    = ["unrelated-cluster-xyz"]
    selection_tag = [{
      key   = "team"
      type  = "STRINGEQUALS"
      value = "other"
    }]
  }
}

# FAIL: backup_retention_period = 0; matched (via cluster_identifier substring) to a
# backup selection linked to a NON-compliant plan (rate(2 days) = 48h > required 24h).
resource "aws_rds_cluster" "fail_identifier_match_insufficient_plan_frequency_f3" {
  expect_failure = true
  attrs = {
    cluster_identifier      = "aurora-cluster-4"
    engine                  = "aurora-mysql"
    backup_retention_period = 0
    tags                    = {}
    arn                     = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-4"
  }
}

# PASS: backup_retention_period = 0; matched (via selection_tag) to a backup selection
# linked to a compliant plan (rate(1 day) = 24h <= required 24h).
resource "aws_rds_cluster" "pass_tag_match_compliant_plan_f3" {
  attrs = {
    cluster_identifier      = "aurora-cluster-5"
    engine                  = "aurora-postgresql"
    backup_retention_period = 0
    tags = {
      team = "payments"
    }
    arn = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-5"
  }
}

# FAIL: backup_retention_period = 0; a backup selection exists in the plan, but neither
# its resources list nor its selection_tag match this cluster, so it provides no cover.
resource "aws_rds_cluster" "fail_selection_present_no_match_f3" {
  expect_failure = true
  attrs = {
    cluster_identifier      = "aurora-cluster-6"
    engine                  = "aurora-mysql"
    backup_retention_period = 0
    tags = {
      team = "finance"
    }
    arn = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-6"
  }
}

# ---- Cases merged from aurora-recovery-point-created-6.policytest.hcl ----

# PASS: required coverage window is 1 hour; 1 day (24h) of backup_retention_period
# comfortably covers it.
resource "aws_rds_cluster" "pass_hourly_requirement_satisfied_by_daily_retention_f6" {
  attrs = {
    cluster_identifier      = "aurora-cluster-10"
    engine                  = "aurora-mysql"
    backup_retention_period = 1
    tags                    = {}
    arn                     = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-10"
  }
}

# ---- Cases merged from aurora-recovery-point-created-cron.policytest.hcl ----

resource "aws_backup_plan" "plan_weekly_f7" {
  skip = true
  attrs = {
    id   = "plan-cron-weekly"
    arn  = "arn:aws:backup:us-east-1:111111111111:backup-plan:plan-cron-weekly"
    name = "plan-cron-weekly"
    rule = [{ rule_name = "r", target_vault_name = "v", schedule = "cron(0 5 ? * MON *)" }]
  }
}

resource "aws_backup_selection" "sel_weekly_f7" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup"
    name          = "sel-cron-weekly"
    plan_id       = "plan-cron-weekly"
    resources     = ["arn:aws:rds:us-east-1:111111111111:cluster:cron-weekly"]
    selection_tag = []
  }
}

resource "aws_rds_cluster" "fail_cron_weekly_f7" {
  expect_failure = true
  attrs = {
    cluster_identifier      = "cron-weekly"
    engine                  = "aurora-mysql"
    backup_retention_period = 0
    tags                    = {}
    arn                     = "arn:aws:rds:us-east-1:111111111111:cluster:cron-weekly"
  }
}

resource "aws_backup_plan" "plan_monthly_f7" {
  skip = true
  attrs = {
    id   = "plan-cron-monthly"
    arn  = "arn:aws:backup:us-east-1:111111111111:backup-plan:plan-cron-monthly"
    name = "plan-cron-monthly"
    rule = [{ rule_name = "r", target_vault_name = "v", schedule = "cron(0 5 1 * ? *)" }]
  }
}

resource "aws_backup_selection" "sel_monthly_f7" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup"
    name          = "sel-cron-monthly"
    plan_id       = "plan-cron-monthly"
    resources     = ["arn:aws:rds:us-east-1:111111111111:cluster:cron-monthly"]
    selection_tag = []
  }
}

resource "aws_rds_cluster" "fail_cron_monthly_f7" {
  expect_failure = true
  attrs = {
    cluster_identifier      = "cron-monthly"
    engine                  = "aurora-mysql"
    backup_retention_period = 0
    tags                    = {}
    arn                     = "arn:aws:rds:us-east-1:111111111111:cluster:cron-monthly"
  }
}

resource "aws_backup_plan" "plan_daily_q_f7" {
  skip = true
  attrs = {
    id   = "plan-cron-daily-q"
    arn  = "arn:aws:backup:us-east-1:111111111111:backup-plan:plan-cron-daily-q"
    name = "plan-cron-daily-q"
    rule = [{ rule_name = "r", target_vault_name = "v", schedule = "cron(0 5 ? * * *)" }]
  }
}

resource "aws_backup_selection" "sel_daily_q_f7" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup"
    name          = "sel-cron-daily-q"
    plan_id       = "plan-cron-daily-q"
    resources     = ["arn:aws:rds:us-east-1:111111111111:cluster:cron-daily-q"]
    selection_tag = []
  }
}

resource "aws_rds_cluster" "pass_cron_daily_q_f7" {
  attrs = {
    cluster_identifier      = "cron-daily-q"
    engine                  = "aurora-mysql"
    backup_retention_period = 0
    tags                    = {}
    arn                     = "arn:aws:rds:us-east-1:111111111111:cluster:cron-daily-q"
  }
}

resource "aws_backup_plan" "plan_every6h_f7" {
  skip = true
  attrs = {
    id   = "plan-cron-every6h"
    arn  = "arn:aws:backup:us-east-1:111111111111:backup-plan:plan-cron-every6h"
    name = "plan-cron-every6h"
    rule = [{ rule_name = "r", target_vault_name = "v", schedule = "cron(0 */6 * * ? *)" }]
  }
}

resource "aws_backup_selection" "sel_every6h_f7" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup"
    name          = "sel-cron-every6h"
    plan_id       = "plan-cron-every6h"
    resources     = ["arn:aws:rds:us-east-1:111111111111:cluster:cron-every6h"]
    selection_tag = []
  }
}

resource "aws_rds_cluster" "pass_cron_every6h_f7" {
  attrs = {
    cluster_identifier      = "cron-every6h"
    engine                  = "aurora-mysql"
    backup_retention_period = 0
    tags                    = {}
    arn                     = "arn:aws:rds:us-east-1:111111111111:cluster:cron-every6h"
  }
}
