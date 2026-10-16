# Copyright IBM Corp. 2026

# Separate file: isolates the "*" wildcard and generic
# "arn:aws:dynamodb:*:*:table/*" ARN-pattern matching scenarios. Both patterns
# match ANY aws_dynamodb_table resource visible via core::getresources() in
# this file, so this file intentionally contains ONLY tables that are meant
# to be covered by one of these broad patterns (both scenarios are PASS
# cases, so there is no conflict between them). Mixing a "should fail due to
# no coverage" table into this file would be incorrectly covered by the
# wildcard/generic selections below. Assumes default inputs (same as the main
# test file: backup_period_days=1, resource_id="", resource_tags="",
# recovery_point_age_value=1, recovery_point_age_unit="days" => required_hours=24).

policytest {
  targets = ["dynamo-db-recovery-point-created.policy.hcl"]
}

resource "aws_backup_plan" "plan_compliant_daily" {
  skip = true
  attrs = {
    id   = "plan-compliant-daily-2"
    arn  = "arn:aws:backup:us-east-1:333333333333:backup-plan:plan-compliant-daily-2"
    name = "plan-compliant-daily-2"
    rule = [{
      rule_name         = "daily-rule"
      target_vault_name = "default-vault"
      schedule          = "rate(1 day)"
    }]
  }
}

# PASS: table covered via the literal wildcard "*" in a selection's resources list.
resource "aws_dynamodb_table" "wildcard_star_covered" {
  attrs = {
    name     = "wildcard-star-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
    arn  = "arn:aws:dynamodb:us-east-1:333333333333:table/wildcard-star-table"
  }
}

resource "aws_backup_selection" "selection_wildcard_star" {
  skip = true
  attrs = {
    iam_role_arn = "arn:aws:iam::333333333333:role/backup-role"
    name         = "selection-wildcard-star"
    plan_id      = aws_backup_plan.plan_compliant_daily.id
    resources     = ["*"]
    selection_tag = []
  }
}

# PASS: table covered via the generic DynamoDB wildcard ARN pattern.
resource "aws_dynamodb_table" "generic_arn_pattern_covered" {
  attrs = {
    name     = "generic-arn-pattern-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
    arn  = "arn:aws:dynamodb:us-east-1:333333333333:table/generic-arn-pattern-table"
  }
}

resource "aws_backup_selection" "selection_generic_arn_pattern" {
  skip = true
  attrs = {
    iam_role_arn = "arn:aws:iam::333333333333:role/backup-role"
    name         = "selection-generic-arn-pattern"
    plan_id      = aws_backup_plan.plan_compliant_daily.id
    resources     = ["arn:aws:dynamodb:*:*:table/*"]
    selection_tag = []
  }
}
