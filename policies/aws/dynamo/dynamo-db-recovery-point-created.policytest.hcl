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

# 1. PASS: PITR enabled, no backup coverage needed at all.
resource "aws_dynamodb_table" "pitr_enabled" {
  attrs = {
    name     = "pitr-enabled-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = true }]
    tags = {}
  }
}

# 2. FAIL: PITR disabled, no AWS Backup selection/plan reference this table at all.
resource "aws_dynamodb_table" "no_coverage" {
  expect_failure = true
  attrs = {
    name     = "no-coverage-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
  }
}

# 3. FAIL (missing attribute edge case): point_in_time_recovery omitted entirely.
resource "aws_dynamodb_table" "pitr_block_omitted" {
  expect_failure = true
  attrs = {
    name     = "pitr-omitted-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    tags = {}
    # point_in_time_recovery intentionally omitted
  }
}

# 4. FAIL (empty list edge case): point_in_time_recovery explicitly empty list.
resource "aws_dynamodb_table" "pitr_empty_list" {
  expect_failure = true
  attrs = {
    name     = "pitr-empty-list-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = []
    tags = {}
  }
}

# 5. PASS: exact ARN match + compliant plan (rate(1 day) = 24h <= required 24h).
resource "aws_dynamodb_table" "exact_arn_compliant" {
  attrs = {
    name     = "exact-arn-compliant-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
    arn  = "arn:aws:dynamodb:us-east-1:111111111111:table/exact-arn-compliant-table"
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
    iam_role_arn = "arn:aws:iam::111111111111:role/backup-role"
    name         = "selection-exact-arn-compliant"
    plan_id      = aws_backup_plan.plan_compliant_daily.id
    resources    = [aws_dynamodb_table.exact_arn_compliant.arn]
    selection_tag = []
  }
}

# 6. FAIL: exact ARN match but linked plan's schedule (rate(7 days)=168h) exceeds 24h.
resource "aws_dynamodb_table" "exact_arn_noncompliant_plan" {
  expect_failure = true
  attrs = {
    name     = "exact-arn-noncompliant-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
    arn  = "arn:aws:dynamodb:us-east-1:111111111111:table/exact-arn-noncompliant-table"
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
    iam_role_arn = "arn:aws:iam::111111111111:role/backup-role"
    name         = "selection-exact-arn-noncompliant"
    plan_id      = aws_backup_plan.plan_noncompliant_weekly.id
    resources    = [aws_dynamodb_table.exact_arn_noncompliant_plan.arn]
    selection_tag = []
  }
}

# 7. FAIL: selection exists and has a compliant plan, but its resources list
# references a DIFFERENT table's ARN (not this table) - no coverage for this table.
resource "aws_dynamodb_table" "not_referenced_table" {
  expect_failure = true
  attrs = {
    name     = "not-referenced-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
    arn  = "arn:aws:dynamodb:us-east-1:111111111111:table/not-referenced-table"
  }
}

resource "aws_backup_selection" "selection_points_elsewhere" {
  skip = true
  attrs = {
    iam_role_arn = "arn:aws:iam::111111111111:role/backup-role"
    name         = "selection-points-elsewhere"
    plan_id      = aws_backup_plan.plan_compliant_daily.id
    resources    = ["arn:aws:dynamodb:us-east-1:111111111111:table/some-other-table"]
    selection_tag = []
  }
}

# 8. FAIL: a selection exists with an otherwise-compliant plan but BOTH its
# resources list and selection_tag list are empty - it must match nothing
# (regression guard against vacuous-truth on an empty selection_tag list).
resource "aws_dynamodb_table" "empty_selection_no_match" {
  expect_failure = true
  attrs = {
    name     = "empty-selection-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
    arn  = "arn:aws:dynamodb:us-east-1:111111111111:table/empty-selection-table"
  }
}

resource "aws_backup_selection" "selection_fully_empty" {
  skip = true
  attrs = {
    iam_role_arn = "arn:aws:iam::111111111111:role/backup-role"
    name         = "selection-fully-empty"
    plan_id      = aws_backup_plan.plan_compliant_daily.id
    resources     = []
    selection_tag = []
  }
}

# 9. PASS: ARN-suffix match (":table/<name>") with a compliant plan.
resource "aws_dynamodb_table" "suffix_match_table" {
  attrs = {
    name     = "orders"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
    arn  = "arn:aws:dynamodb:us-east-1:222222222222:table/orders"
  }
}

resource "aws_backup_selection" "selection_suffix_match" {
  skip = true
  attrs = {
    iam_role_arn = "arn:aws:iam::111111111111:role/backup-role"
    name         = "selection-suffix-match"
    plan_id      = aws_backup_plan.plan_compliant_daily.id
    resources    = ["arn:aws:dynamodb:us-east-1:999999999999:table/orders"]
    selection_tag = []
  }
}

# 10. PASS: tag-based selection_tag match, resources list empty.
resource "aws_dynamodb_table" "tag_match_table" {
  attrs = {
    name     = "tag-match-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = { Environment = "prod" }
  }
}

resource "aws_backup_selection" "selection_tag_match" {
  skip = true
  attrs = {
    iam_role_arn = "arn:aws:iam::111111111111:role/backup-role"
    name         = "selection-tag-match"
    plan_id      = aws_backup_plan.plan_compliant_daily.id
    resources     = []
    selection_tag = [{ key = "Environment", type = "STRINGEQUALS", value = "prod" }]
  }
}

# 11. FAIL: table tags do NOT match the selection's selection_tag entries.
resource "aws_dynamodb_table" "tag_mismatch_table" {
  expect_failure = true
  attrs = {
    name     = "tag-mismatch-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = { Environment = "dev" }
  }
}

resource "aws_backup_selection" "selection_tag_mismatch" {
  skip = true
  attrs = {
    iam_role_arn = "arn:aws:iam::111111111111:role/backup-role"
    name         = "selection-tag-mismatch"
    plan_id      = aws_backup_plan.plan_compliant_daily.id
    resources     = []
    selection_tag = [{ key = "Environment", type = "STRINGEQUALS", value = "prod" }]
  }
}

# 12. PASS (boundary): linked plan's schedule frequency exactly equals the
# required window (rate(1 day) = 24h, required_hours = 24).
resource "aws_dynamodb_table" "boundary_exact_hours" {
  attrs = {
    name     = "boundary-exact-hours-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
    arn  = "arn:aws:dynamodb:us-east-1:111111111111:table/boundary-exact-hours-table"
  }
}

resource "aws_backup_selection" "selection_boundary_exact_hours" {
  skip = true
  attrs = {
    iam_role_arn = "arn:aws:iam::111111111111:role/backup-role"
    name         = "selection-boundary-exact-hours"
    plan_id      = aws_backup_plan.plan_compliant_daily.id
    resources    = [aws_dynamodb_table.boundary_exact_hours.arn]
    selection_tag = []
  }
}
