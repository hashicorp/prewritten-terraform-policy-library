# Copyright IBM Corp. 2026

# Separate file: assumes a different inputs {} block (backup_period_days=3,
# recoveryPointAgeValue/recoveryPointAgeUnit left at their defaults of 1/"days"
# => required_hours=72). A policytest file can declare only one inputs {}
# block, so this scenario set needs its own file.

policytest {
  targets = ["dynamo-db-recovery-point-created.policy.hcl"]
}

inputs {
  dynamo-db-recovery-point-created-backup_period_days = 3
}

# PASS (boundary): linked plan schedule (rate(3 days) = 72h) exactly equals
# the required 72h window.
resource "aws_dynamodb_table" "plan_exactly_72h_boundary" {
  attrs = {
    name     = "plan-exactly-72h-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
    arn  = "arn:aws:dynamodb:us-east-1:555555555555:table/plan-exactly-72h-table"
  }
}

resource "aws_backup_plan" "plan_3day_72h" {
  skip = true
  attrs = {
    id   = "plan-3day-72h"
    arn  = "arn:aws:backup:us-east-1:555555555555:backup-plan:plan-3day-72h"
    name = "plan-3day-72h"
    rule = [{
      rule_name         = "three-day-rule"
      target_vault_name = "default-vault"
      schedule          = "rate(3 days)"
    }]
  }
}

resource "aws_backup_selection" "selection_exactly_72h" {
  skip = true
  attrs = {
    iam_role_arn = "arn:aws:iam::555555555555:role/backup-role"
    name         = "selection-exactly-72h"
    plan_id      = aws_backup_plan.plan_3day_72h.id
    resources    = [aws_dynamodb_table.plan_exactly_72h_boundary.arn]
    selection_tag = []
  }
}

# FAIL: linked plan schedule (rate(4 days) = 96h) exceeds the required 72h window.
resource "aws_dynamodb_table" "plan_exceeds_72h" {
  expect_failure = true
  attrs = {
    name     = "plan-exceeds-72h-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
    arn  = "arn:aws:dynamodb:us-east-1:555555555555:table/plan-exceeds-72h-table"
  }
}

resource "aws_backup_plan" "plan_4day_96h" {
  skip = true
  attrs = {
    id   = "plan-4day-96h"
    arn  = "arn:aws:backup:us-east-1:555555555555:backup-plan:plan-4day-96h"
    name = "plan-4day-96h"
    rule = [{
      rule_name         = "four-day-rule"
      target_vault_name = "default-vault"
      schedule          = "rate(4 days)"
    }]
  }
}

resource "aws_backup_selection" "selection_exceeds_72h" {
  skip = true
  attrs = {
    iam_role_arn = "arn:aws:iam::555555555555:role/backup-role"
    name         = "selection-exceeds-72h"
    plan_id      = aws_backup_plan.plan_4day_96h.id
    resources    = [aws_dynamodb_table.plan_exceeds_72h.arn]
    selection_tag = []
  }
}
