# Copyright IBM Corp. 2026

# cron() schedule parsing: weekly and monthly crons must fail a 24-hour requirement;
# daily crons (day-of-month "?") and every-6-hours crons must pass. Default inputs.

policytest {
  targets = ["aurora-recovery-point-created.policy.hcl"]
}

resource "aws_backup_plan" "plan_weekly" {
  skip = true
  attrs = {
    id   = "plan-cron-weekly"
    arn  = "arn:aws:backup:us-east-1:111111111111:backup-plan:plan-cron-weekly"
    name = "plan-cron-weekly"
    rule = [{ rule_name = "r", target_vault_name = "v", schedule = "cron(0 5 ? * MON *)" }]
  }
}

resource "aws_backup_selection" "sel_weekly" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup"
    name          = "sel-cron-weekly"
    plan_id       = "plan-cron-weekly"
    resources     = ["arn:aws:rds:us-east-1:111111111111:cluster:cron-weekly"]
    selection_tag = []
  }
}

resource "aws_rds_cluster" "fail_cron_weekly" {
  expect_failure = true
  attrs = {
    cluster_identifier = "cron-weekly"
    engine = "aurora-mysql"
    backup_retention_period = 0
    tags = {}
    arn = "arn:aws:rds:us-east-1:111111111111:cluster:cron-weekly"
  }
}

resource "aws_backup_plan" "plan_monthly" {
  skip = true
  attrs = {
    id   = "plan-cron-monthly"
    arn  = "arn:aws:backup:us-east-1:111111111111:backup-plan:plan-cron-monthly"
    name = "plan-cron-monthly"
    rule = [{ rule_name = "r", target_vault_name = "v", schedule = "cron(0 5 1 * ? *)" }]
  }
}

resource "aws_backup_selection" "sel_monthly" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup"
    name          = "sel-cron-monthly"
    plan_id       = "plan-cron-monthly"
    resources     = ["arn:aws:rds:us-east-1:111111111111:cluster:cron-monthly"]
    selection_tag = []
  }
}

resource "aws_rds_cluster" "fail_cron_monthly" {
  expect_failure = true
  attrs = {
    cluster_identifier = "cron-monthly"
    engine = "aurora-mysql"
    backup_retention_period = 0
    tags = {}
    arn = "arn:aws:rds:us-east-1:111111111111:cluster:cron-monthly"
  }
}

resource "aws_backup_plan" "plan_daily_q" {
  skip = true
  attrs = {
    id   = "plan-cron-daily-q"
    arn  = "arn:aws:backup:us-east-1:111111111111:backup-plan:plan-cron-daily-q"
    name = "plan-cron-daily-q"
    rule = [{ rule_name = "r", target_vault_name = "v", schedule = "cron(0 5 ? * * *)" }]
  }
}

resource "aws_backup_selection" "sel_daily_q" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup"
    name          = "sel-cron-daily-q"
    plan_id       = "plan-cron-daily-q"
    resources     = ["arn:aws:rds:us-east-1:111111111111:cluster:cron-daily-q"]
    selection_tag = []
  }
}

resource "aws_rds_cluster" "pass_cron_daily_q" {
  attrs = {
    cluster_identifier = "cron-daily-q"
    engine = "aurora-mysql"
    backup_retention_period = 0
    tags = {}
    arn = "arn:aws:rds:us-east-1:111111111111:cluster:cron-daily-q"
  }
}

resource "aws_backup_plan" "plan_every6h" {
  skip = true
  attrs = {
    id   = "plan-cron-every6h"
    arn  = "arn:aws:backup:us-east-1:111111111111:backup-plan:plan-cron-every6h"
    name = "plan-cron-every6h"
    rule = [{ rule_name = "r", target_vault_name = "v", schedule = "cron(0 */6 * * ? *)" }]
  }
}

resource "aws_backup_selection" "sel_every6h" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup"
    name          = "sel-cron-every6h"
    plan_id       = "plan-cron-every6h"
    resources     = ["arn:aws:rds:us-east-1:111111111111:cluster:cron-every6h"]
    selection_tag = []
  }
}

resource "aws_rds_cluster" "pass_cron_every6h" {
  attrs = {
    cluster_identifier = "cron-every6h"
    engine = "aurora-mysql"
    backup_retention_period = 0
    tags = {}
    arn = "arn:aws:rds:us-east-1:111111111111:cluster:cron-every6h"
  }
}
