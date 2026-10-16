# Copyright IBM Corp. 2026

# cron() schedule parsing: weekly and monthly crons must fail a 24-hour requirement;
# daily crons (day-of-month "?") and every-6-hours crons must pass. Default inputs.

policytest {
  targets = ["dynamo-db-recovery-point-created.policy.hcl"]
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
    resources     = ["arn:aws:dynamodb:us-east-1:111111111111:table/cron-weekly"]
    selection_tag = []
  }
}

resource "aws_dynamodb_table" "fail_cron_weekly" {
  expect_failure = true
  attrs = {
    name = "cron-weekly"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
    arn = "arn:aws:dynamodb:us-east-1:111111111111:table/cron-weekly"
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
    resources     = ["arn:aws:dynamodb:us-east-1:111111111111:table/cron-monthly"]
    selection_tag = []
  }
}

resource "aws_dynamodb_table" "fail_cron_monthly" {
  expect_failure = true
  attrs = {
    name = "cron-monthly"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
    arn = "arn:aws:dynamodb:us-east-1:111111111111:table/cron-monthly"
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
    resources     = ["arn:aws:dynamodb:us-east-1:111111111111:table/cron-daily-q"]
    selection_tag = []
  }
}

resource "aws_dynamodb_table" "pass_cron_daily_q" {
  attrs = {
    name = "cron-daily-q"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
    arn = "arn:aws:dynamodb:us-east-1:111111111111:table/cron-daily-q"
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
    resources     = ["arn:aws:dynamodb:us-east-1:111111111111:table/cron-every6h"]
    selection_tag = []
  }
}

resource "aws_dynamodb_table" "pass_cron_every6h" {
  attrs = {
    name = "cron-every6h"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
    arn = "arn:aws:dynamodb:us-east-1:111111111111:table/cron-every6h"
  }
}
