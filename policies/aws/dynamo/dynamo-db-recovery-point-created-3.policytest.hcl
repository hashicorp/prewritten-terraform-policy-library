# Copyright IBM Corp. 2026

# Separate file: assumes a different inputs {} block (recovery_point_age_value=2,
# recovery_point_age_unit="hours" => required_hours=2). A policytest file can
# declare only one inputs {} block, so this scenario set needs its own file.

policytest {
  targets = ["dynamo-db-recovery-point-created.policy.hcl"]
}

inputs {
  dynamo-db-recovery-point-created-recovery_point_age_value = 2
  dynamo-db-recovery-point-created-recovery_point_age_unit  = "hours"
}

# PASS: PITR enabled - always compliant regardless of the required window.
resource "aws_dynamodb_table" "pitr_enabled_custom_window" {
  attrs = {
    name     = "pitr-enabled-custom-window-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = true }]
    tags = {}
  }
}

# FAIL: linked plan schedule (rate(1 day) = 24h) exceeds the tightened 2h window.
resource "aws_dynamodb_table" "plan_exceeds_custom_window" {
  expect_failure = true
  attrs = {
    name     = "plan-exceeds-custom-window-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
    arn  = "arn:aws:dynamodb:us-east-1:444444444444:table/plan-exceeds-custom-window-table"
  }
}

resource "aws_backup_plan" "plan_daily_24h" {
  skip = true
  attrs = {
    id   = "plan-daily-24h"
    arn  = "arn:aws:backup:us-east-1:444444444444:backup-plan:plan-daily-24h"
    name = "plan-daily-24h"
    rule = [{
      rule_name         = "daily-rule"
      target_vault_name = "default-vault"
      schedule          = "rate(1 day)"
    }]
  }
}

resource "aws_backup_selection" "selection_exceeds_custom_window" {
  skip = true
  attrs = {
    iam_role_arn = "arn:aws:iam::444444444444:role/backup-role"
    name         = "selection-exceeds-custom-window"
    plan_id      = aws_backup_plan.plan_daily_24h.id
    resources    = [aws_dynamodb_table.plan_exceeds_custom_window.arn]
    selection_tag = []
  }
}

# PASS: linked plan schedule (rate(1 hour) = 1h) is within the tightened 2h window.
resource "aws_dynamodb_table" "plan_within_custom_window" {
  attrs = {
    name     = "plan-within-custom-window-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
    arn  = "arn:aws:dynamodb:us-east-1:444444444444:table/plan-within-custom-window-table"
  }
}

resource "aws_backup_plan" "plan_hourly_1h" {
  skip = true
  attrs = {
    id   = "plan-hourly-1h"
    arn  = "arn:aws:backup:us-east-1:444444444444:backup-plan:plan-hourly-1h"
    name = "plan-hourly-1h"
    rule = [{
      rule_name         = "hourly-rule"
      target_vault_name = "default-vault"
      schedule          = "rate(1 hour)"
    }]
  }
}

resource "aws_backup_selection" "selection_within_custom_window" {
  skip = true
  attrs = {
    iam_role_arn = "arn:aws:iam::444444444444:role/backup-role"
    name         = "selection-within-custom-window"
    plan_id      = aws_backup_plan.plan_hourly_1h.id
    resources    = [aws_dynamodb_table.plan_within_custom_window.arn]
    selection_tag = []
  }
}
