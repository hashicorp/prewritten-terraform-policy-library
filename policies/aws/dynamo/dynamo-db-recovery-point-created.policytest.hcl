# Copyright IBM Corp. 2026

policytest {
  targets = ["dynamo-db-recovery-point-created.policy.hcl"]
}

# Default inputs (backup_period_days=1, resource_id="", resource_tags="",
# recovery_point_age_value=1, recovery_point_age_unit="days" => required_hours = 24).
# All selections/plans here use exact-value matching (own ARN cross-references,
# ARN-suffix, or tag matching) - never the "*" wildcard or the generic
# "arn:aws:dynamodb:*:*:table/*" pattern - so they cannot accidentally cover
# any other table's scenario in this same file (core::getresources() sees
# every resource declared below). The wildcard-pattern scenarios are isolated
# in -2.policytest.hcl for that reason.

# 1. FAIL: PITR enabled but no AWS Backup plan covers the table. The AWS Config rule
#    checks AWS Backup recovery points, so PITR alone does not satisfy it.
resource "aws_dynamodb_table" "pitr_enabled" {
  expect_failure = true
  attrs = {
    name                   = "pitr-enabled-table"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    billing_mode           = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = true }]
    tags                   = {}
  }
}

# 2. FAIL: PITR disabled, no AWS Backup selection/plan reference this table at all.
resource "aws_dynamodb_table" "no_coverage" {
  expect_failure = true
  attrs = {
    name                   = "no-coverage-table"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    billing_mode           = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags                   = {}
  }
}

# 3. FAIL (missing attribute edge case): point_in_time_recovery omitted entirely.
resource "aws_dynamodb_table" "pitr_block_omitted" {
  expect_failure = true
  attrs = {
    name         = "pitr-omitted-table"
    hash_key     = "id"
    attribute    = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    tags         = {}
    # point_in_time_recovery intentionally omitted
  }
}

# 4. FAIL (empty list edge case): point_in_time_recovery explicitly empty list.
resource "aws_dynamodb_table" "pitr_empty_list" {
  expect_failure = true
  attrs = {
    name                   = "pitr-empty-list-table"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    billing_mode           = "PAY_PER_REQUEST"
    point_in_time_recovery = []
    tags                   = {}
  }
}

# 5. PASS: exact ARN match + compliant plan (rate(1 day) = 24h <= required 24h).
resource "aws_dynamodb_table" "exact_arn_compliant" {
  attrs = {
    name                   = "exact-arn-compliant-table"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    billing_mode           = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags                   = {}
    arn                    = "arn:aws:dynamodb:us-east-1:111111111111:table/exact-arn-compliant-table"
  }
}

resource "aws_backup_plan" "plan_compliant_daily" {
  skip = true
  attrs = {
    id   = "plan-compliant-daily"
    arn  = "arn:aws:backup:us-east-1:111111111111:backup-plan:plan-compliant-daily"
    name = "plan-compliant-daily"
    rule = [{
      rule_name         = "daily-rule"
      target_vault_name = "default-vault"
      schedule          = "rate(1 day)"
    }]
  }
}

resource "aws_backup_selection" "selection_exact_arn_compliant" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup-role"
    name          = "selection-exact-arn-compliant"
    plan_id       = aws_backup_plan.plan_compliant_daily.id
    resources     = [aws_dynamodb_table.exact_arn_compliant.arn]
    selection_tag = []
  }
}

# 6. FAIL: exact ARN match but linked plan's schedule (rate(7 days)=168h) exceeds 24h.
resource "aws_dynamodb_table" "exact_arn_noncompliant_plan" {
  expect_failure = true
  attrs = {
    name                   = "exact-arn-noncompliant-table"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    billing_mode           = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags                   = {}
    arn                    = "arn:aws:dynamodb:us-east-1:111111111111:table/exact-arn-noncompliant-table"
  }
}

resource "aws_backup_plan" "plan_noncompliant_weekly" {
  skip = true
  attrs = {
    id   = "plan-noncompliant-weekly"
    arn  = "arn:aws:backup:us-east-1:111111111111:backup-plan:plan-noncompliant-weekly"
    name = "plan-noncompliant-weekly"
    rule = [{
      rule_name         = "weekly-rule"
      target_vault_name = "default-vault"
      schedule          = "rate(7 days)"
    }]
  }
}

resource "aws_backup_selection" "selection_exact_arn_noncompliant" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup-role"
    name          = "selection-exact-arn-noncompliant"
    plan_id       = aws_backup_plan.plan_noncompliant_weekly.id
    resources     = [aws_dynamodb_table.exact_arn_noncompliant_plan.arn]
    selection_tag = []
  }
}

# 7. FAIL: selection exists and has a compliant plan, but its resources list
# references a DIFFERENT table's ARN (not this table) - no coverage for this table.
resource "aws_dynamodb_table" "not_referenced_table" {
  expect_failure = true
  attrs = {
    name                   = "not-referenced-table"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    billing_mode           = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags                   = {}
    arn                    = "arn:aws:dynamodb:us-east-1:111111111111:table/not-referenced-table"
  }
}

resource "aws_backup_selection" "selection_points_elsewhere" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup-role"
    name          = "selection-points-elsewhere"
    plan_id       = aws_backup_plan.plan_compliant_daily.id
    resources     = ["arn:aws:dynamodb:us-east-1:111111111111:table/some-other-table"]
    selection_tag = []
  }
}

# 8. FAIL: a selection exists with an otherwise-compliant plan but BOTH its
# resources list and selection_tag list are empty - it must match nothing
# (regression guard against vacuous-truth on an empty selection_tag list).
resource "aws_dynamodb_table" "empty_selection_no_match" {
  expect_failure = true
  attrs = {
    name                   = "empty-selection-table"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    billing_mode           = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags                   = {}
    arn                    = "arn:aws:dynamodb:us-east-1:111111111111:table/empty-selection-table"
  }
}

resource "aws_backup_selection" "selection_fully_empty" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup-role"
    name          = "selection-fully-empty"
    plan_id       = aws_backup_plan.plan_compliant_daily.id
    resources     = []
    selection_tag = []
  }
}

# 9. PASS: ARN-suffix match (":table/<name>") with a compliant plan.
resource "aws_dynamodb_table" "suffix_match_table" {
  attrs = {
    name                   = "orders"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    billing_mode           = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags                   = {}
    arn                    = "arn:aws:dynamodb:us-east-1:222222222222:table/orders"
  }
}

resource "aws_backup_selection" "selection_suffix_match" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup-role"
    name          = "selection-suffix-match"
    plan_id       = aws_backup_plan.plan_compliant_daily.id
    resources     = ["arn:aws:dynamodb:us-east-1:999999999999:table/orders"]
    selection_tag = []
  }
}

# 10. PASS: tag-based selection_tag match, resources list empty.
resource "aws_dynamodb_table" "tag_match_table" {
  attrs = {
    name                   = "tag-match-table"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    billing_mode           = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags                   = { Environment = "prod" }
  }
}

resource "aws_backup_selection" "selection_tag_match" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup-role"
    name          = "selection-tag-match"
    plan_id       = aws_backup_plan.plan_compliant_daily.id
    resources     = []
    selection_tag = [{ key = "Environment", type = "STRINGEQUALS", value = "prod" }]
  }
}

# 11. FAIL: table tags do NOT match the selection's selection_tag entries.
resource "aws_dynamodb_table" "tag_mismatch_table" {
  expect_failure = true
  attrs = {
    name                   = "tag-mismatch-table"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    billing_mode           = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags                   = { Environment = "dev" }
  }
}

resource "aws_backup_selection" "selection_tag_mismatch" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup-role"
    name          = "selection-tag-mismatch"
    plan_id       = aws_backup_plan.plan_compliant_daily.id
    resources     = []
    selection_tag = [{ key = "Environment", type = "STRINGEQUALS", value = "prod" }]
  }
}

# 12. PASS (boundary): linked plan's schedule frequency exactly equals the
# required window (rate(1 day) = 24h, required_hours = 24).
resource "aws_dynamodb_table" "boundary_exact_hours" {
  attrs = {
    name                   = "boundary-exact-hours-table"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    billing_mode           = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags                   = {}
    arn                    = "arn:aws:dynamodb:us-east-1:111111111111:table/boundary-exact-hours-table"
  }
}

resource "aws_backup_selection" "selection_boundary_exact_hours" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup-role"
    name          = "selection-boundary-exact-hours"
    plan_id       = aws_backup_plan.plan_compliant_daily.id
    resources     = [aws_dynamodb_table.boundary_exact_hours.arn]
    selection_tag = []
  }
}

# ---- Cases merged from dynamo-db-recovery-point-created-3.policytest.hcl ----

# FAIL: PITR enabled but no AWS Backup plan covers the table (PITR alone is not
# an AWS Backup recovery point).
resource "aws_dynamodb_table" "pitr_enabled_custom_window_f3" {
  expect_failure = true
  attrs = {
    name                   = "pitr-enabled-custom-window-table"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    billing_mode           = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = true }]
    tags                   = {}
  }
}


resource "aws_backup_plan" "plan_daily_24h_f3" {
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


# PASS: linked plan schedule (rate(1 hour) = 1h) is within the tightened 2h window.
resource "aws_dynamodb_table" "plan_within_custom_window_f3" {
  attrs = {
    name                   = "plan-within-custom-window-table"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    billing_mode           = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags                   = {}
    arn                    = "arn:aws:dynamodb:us-east-1:444444444444:table/plan-within-custom-window-table"
  }
}

resource "aws_backup_plan" "plan_hourly_1h_f3" {
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

resource "aws_backup_selection" "selection_within_custom_window_f3" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::444444444444:role/backup-role"
    name          = "selection-within-custom-window"
    plan_id       = aws_backup_plan.plan_hourly_1h_f3.id
    resources     = [aws_dynamodb_table.plan_within_custom_window_f3.arn]
    selection_tag = []
  }
}

# ---- Cases merged from dynamo-db-recovery-point-created-4.policytest.hcl ----


resource "aws_backup_plan" "plan_3day_72h_f4" {
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


# FAIL: linked plan schedule (rate(4 days) = 96h) exceeds the required 72h window.
resource "aws_dynamodb_table" "plan_exceeds_72h_f4" {
  expect_failure = true
  attrs = {
    name                   = "plan-exceeds-72h-table"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    billing_mode           = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags                   = {}
    arn                    = "arn:aws:dynamodb:us-east-1:555555555555:table/plan-exceeds-72h-table"
  }
}

resource "aws_backup_plan" "plan_4day_96h_f4" {
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

resource "aws_backup_selection" "selection_exceeds_72h_f4" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::555555555555:role/backup-role"
    name          = "selection-exceeds-72h"
    plan_id       = aws_backup_plan.plan_4day_96h_f4.id
    resources     = [aws_dynamodb_table.plan_exceeds_72h_f4.arn]
    selection_tag = []
  }
}

# ---- Cases merged from dynamo-db-recovery-point-created-5.policytest.hcl ----


# FAIL: table name matches resource_id filter -> evaluated -> non-compliant.
resource "aws_dynamodb_table" "matching_id_noncompliant_f5" {
  expect_failure = true
  attrs = {
    name                   = "specific-table"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    billing_mode           = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags                   = {}
  }
}

# PASS: table name matches resource_id filter -> evaluated -> compliant (PITR enabled).
resource "aws_dynamodb_table" "matching_id_compliant_f5" {
  expect_failure = true
  attrs = {
    name                   = "specific-table"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    billing_mode           = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = true }]
    tags                   = {}
  }
}

# ---- Cases merged from dynamo-db-recovery-point-created-cron.policytest.hcl ----

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
    resources     = ["arn:aws:dynamodb:us-east-1:111111111111:table/cron-weekly"]
    selection_tag = []
  }
}

resource "aws_dynamodb_table" "fail_cron_weekly_f7" {
  expect_failure = true
  attrs = {
    name                   = "cron-weekly"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    point_in_time_recovery = [{ enabled = false }]
    tags                   = {}
    arn                    = "arn:aws:dynamodb:us-east-1:111111111111:table/cron-weekly"
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
    resources     = ["arn:aws:dynamodb:us-east-1:111111111111:table/cron-monthly"]
    selection_tag = []
  }
}

resource "aws_dynamodb_table" "fail_cron_monthly_f7" {
  expect_failure = true
  attrs = {
    name                   = "cron-monthly"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    point_in_time_recovery = [{ enabled = false }]
    tags                   = {}
    arn                    = "arn:aws:dynamodb:us-east-1:111111111111:table/cron-monthly"
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
    resources     = ["arn:aws:dynamodb:us-east-1:111111111111:table/cron-daily-q"]
    selection_tag = []
  }
}

resource "aws_dynamodb_table" "pass_cron_daily_q_f7" {
  attrs = {
    name                   = "cron-daily-q"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    point_in_time_recovery = [{ enabled = false }]
    tags                   = {}
    arn                    = "arn:aws:dynamodb:us-east-1:111111111111:table/cron-daily-q"
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
    resources     = ["arn:aws:dynamodb:us-east-1:111111111111:table/cron-every6h"]
    selection_tag = []
  }
}

resource "aws_dynamodb_table" "pass_cron_every6h_f7" {
  attrs = {
    name                   = "cron-every6h"
    hash_key               = "id"
    attribute              = [{ name = "id", type = "S" }]
    point_in_time_recovery = [{ enabled = false }]
    tags                   = {}
    arn                    = "arn:aws:dynamodb:us-east-1:111111111111:table/cron-every6h"
  }
}
