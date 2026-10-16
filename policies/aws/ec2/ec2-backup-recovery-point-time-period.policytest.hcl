# Copyright IBM Corp. 2026

policytest {
  targets = ["ec2-backup-recovery-point-time-period.policy.hcl"]
}

# Default inputs (max_recovery_point_age_hours = 24, recovery_point_age_value = 1,
# recovery_point_age_unit = "days", resource_id = "", resource_tags = "").
# Every selection/plan below is linked via an exact ARN (or a unique ARN-suffix /
# selection_tag) scoped to its own scenario's instance only, so none of them
# accidentally cover a different scenario's instance in this same file.

# --- A1: no backup_selection/backup_plan references this instance at all.
# Tags are omitted entirely (missing-attribute coverage case).
resource "aws_instance" "fail_no_coverage" {
  expect_failure = true
  attrs = {
    ami               = "ami-12345678"
    id                = "i-a1"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-a1"
  }
}

# --- A2: tags explicitly null (two-step null-normalization check). No selection
# matches this instance (the selection_tag selection below requires Backup=true, and
# {} has no Backup key once null is normalized), so it stays non-compliant without crashing.
resource "aws_instance" "fail_null_tags" {
  expect_failure = true
  attrs = {
    ami               = "ami-12345678"
    id                = "i-a2"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-a2"
    tags              = null
  }
}

# --- A3: covered by a compliant-looking selection, but the linked plan's rule
# (rate(25 hours)) exceeds the default 24-hour requirement by 1 hour (tight boundary).
resource "aws_instance" "fail_too_frequent_boundary" {
  expect_failure = true
  attrs = {
    ami               = "ami-12345678"
    id                = "i-a3"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-a3"
  }
}

resource "aws_backup_plan" "plan_a3" {
  skip = true
  attrs = {
    id   = "plan-a3"
    arn  = "arn:aws:backup:us-east-1:123456789012:backup-plan:plan-a3"
    name = "plan-a3"
    rule = [{
      rule_name         = "rule-a3"
      target_vault_name = "vault-a3"
      schedule          = "rate(25 hours)"
    }]
  }
}

resource "aws_backup_selection" "selection_a3" {
  skip = true
  attrs = {
    id           = "selection-a3"
    name         = "selection-a3"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    plan_id      = "plan-a3"
    resources    = ["arn:aws:ec2:us-east-1:123456789012:instance/i-a3"]
  }
}

# --- A4: exact ARN match, plan schedule rate(12 hours) <= 24h requirement -> compliant.
resource "aws_instance" "pass_rate_hours" {
  attrs = {
    ami               = "ami-12345678"
    id                = "i-a4"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-a4"
  }
}

resource "aws_backup_plan" "plan_a4" {
  skip = true
  attrs = {
    id   = "plan-a4"
    arn  = "arn:aws:backup:us-east-1:123456789012:backup-plan:plan-a4"
    name = "plan-a4"
    rule = [{
      rule_name         = "rule-a4"
      target_vault_name = "vault-a4"
      schedule          = "rate(12 hours)"
    }]
  }
}

resource "aws_backup_selection" "selection_a4" {
  skip = true
  attrs = {
    id           = "selection-a4"
    name         = "selection-a4"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    plan_id      = "plan-a4"
    resources    = ["arn:aws:ec2:us-east-1:123456789012:instance/i-a4"]
  }
}

# --- A5: the instance's ARN is listed in BOTH resources and not_resources of the same
# selection, so it is explicitly excluded even though the plan itself is compliant.
resource "aws_instance" "fail_excluded_not_resources" {
  expect_failure = true
  attrs = {
    ami               = "ami-12345678"
    id                = "i-a5"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-a5"
  }
}

resource "aws_backup_plan" "plan_a5" {
  skip = true
  attrs = {
    id   = "plan-a5"
    arn  = "arn:aws:backup:us-east-1:123456789012:backup-plan:plan-a5"
    name = "plan-a5"
    rule = [{
      rule_name         = "rule-a5"
      target_vault_name = "vault-a5"
      schedule          = "rate(6 hours)"
    }]
  }
}

resource "aws_backup_selection" "selection_a5" {
  skip = true
  attrs = {
    id            = "selection-a5"
    name          = "selection-a5"
    iam_role_arn  = "arn:aws:iam::123456789012:role/backup-role"
    plan_id       = "plan-a5"
    resources     = ["arn:aws:ec2:us-east-1:123456789012:instance/i-a5"]
    not_resources = ["arn:aws:ec2:us-east-1:123456789012:instance/i-a5"]
  }
}

# --- A6: selection_tag match (STRINGEQUALS Backup=true) + instance tagged Backup=true,
# plan schedule rate(6 hours) -> compliant.
resource "aws_instance" "pass_tag_match" {
  attrs = {
    ami               = "ami-12345678"
    id                = "i-a6"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-a6"
    tags = {
      Backup = "true"
    }
  }
}

resource "aws_backup_plan" "plan_a6" {
  skip = true
  attrs = {
    id   = "plan-a6"
    arn  = "arn:aws:backup:us-east-1:123456789012:backup-plan:plan-a6"
    name = "plan-a6"
    rule = [{
      rule_name         = "rule-a6"
      target_vault_name = "vault-a6"
      schedule          = "rate(6 hours)"
    }]
  }
}

resource "aws_backup_selection" "selection_a6" {
  skip = true
  attrs = {
    id           = "selection-a6"
    name         = "selection-a6"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    plan_id      = "plan-a6"
    selection_tag = [{
      key   = "Backup"
      type  = "STRINGEQUALS"
      value = "true"
    }]
  }
}

# --- A7: same selection_tag requirement as A6 (Backup=true), but this instance is
# tagged Backup=false, so it does not match -> non-compliant (no other coverage).
resource "aws_instance" "fail_tag_mismatch" {
  expect_failure = true
  attrs = {
    ami               = "ami-12345678"
    id                = "i-a7"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-a7"
    tags = {
      Backup = "false"
    }
  }
}

# --- A8: a selection with no resources/selection_tag/condition at all covers nothing
# (empty-collection case). The instance has no other coverage either.
resource "aws_instance" "fail_selection_no_criteria" {
  expect_failure = true
  attrs = {
    ami               = "ami-12345678"
    id                = "i-a8"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-a8"
  }
}

resource "aws_backup_plan" "plan_a8" {
  skip = true
  attrs = {
    id   = "plan-a8"
    arn  = "arn:aws:backup:us-east-1:123456789012:backup-plan:plan-a8"
    name = "plan-a8"
    rule = [{
      rule_name         = "rule-a8"
      target_vault_name = "vault-a8"
      schedule          = "rate(1 hour)"
    }]
  }
}

resource "aws_backup_selection" "selection_a8" {
  skip = true
  attrs = {
    id            = "selection-a8"
    name          = "selection-a8"
    iam_role_arn  = "arn:aws:iam::123456789012:role/backup-role"
    plan_id       = "plan-a8"
    resources     = []
    not_resources = []
    selection_tag = []
    condition     = []
  }
}

# --- A9: selection covers the instance by exact ARN, but its plan_id references a
# backup plan that does not exist anywhere in the plan -> non-compliant.
resource "aws_instance" "fail_plan_id_mismatch" {
  expect_failure = true
  attrs = {
    ami               = "ami-12345678"
    id                = "i-a9"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-a9"
  }
}

resource "aws_backup_selection" "selection_a9" {
  skip = true
  attrs = {
    id           = "selection-a9"
    name         = "selection-a9"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    plan_id      = "plan-does-not-exist"
    resources    = ["arn:aws:ec2:us-east-1:123456789012:instance/i-a9"]
  }
}

# --- A10: selection covers the instance by exact ARN and links to a real plan, but the
# plan's only rule has an empty schedule -> cannot satisfy the frequency requirement.
resource "aws_instance" "fail_empty_schedule_rule" {
  expect_failure = true
  attrs = {
    ami               = "ami-12345678"
    id                = "i-a10"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-a10"
  }
}

resource "aws_backup_plan" "plan_a10" {
  skip = true
  attrs = {
    id   = "plan-a10"
    arn  = "arn:aws:backup:us-east-1:123456789012:backup-plan:plan-a10"
    name = "plan-a10"
    rule = [{
      rule_name         = "rule-a10"
      target_vault_name = "vault-a10"
      schedule          = ""
    }]
  }
}

resource "aws_backup_selection" "selection_a10" {
  skip = true
  attrs = {
    id           = "selection-a10"
    name         = "selection-a10"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    plan_id      = "plan-a10"
    resources    = ["arn:aws:ec2:us-east-1:123456789012:instance/i-a10"]
  }
}

# --- A11: selection references the instance via an ARN-suffix match
# (":instance/<id>", distinct from the instance's own full `arn` attr value), plan
# schedule is cron(0 * * * ? *) (hour field "*" -> approximated as hourly) -> compliant.
resource "aws_instance" "pass_arn_suffix_match" {
  attrs = {
    ami               = "ami-12345678"
    id                = "i-a11"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-a11"
  }
}

resource "aws_backup_plan" "plan_a11" {
  skip = true
  attrs = {
    id   = "plan-a11"
    arn  = "arn:aws:backup:us-east-1:123456789012:backup-plan:plan-a11"
    name = "plan-a11"
    rule = [{
      rule_name         = "rule-a11"
      target_vault_name = "vault-a11"
      schedule          = "cron(0 * * * ? *)"
    }]
  }
}

resource "aws_backup_selection" "selection_a11" {
  skip = true
  attrs = {
    id           = "selection-a11"
    name         = "selection-a11"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    plan_id      = "plan-a11"
    # References the instance by a different (longer) ARN that merely ends in
    # ":instance/i-a11" -- exercises the endswith() suffix-match code path.
    resources = ["arn:aws:ec2:us-east-1:999999999999:instance/i-a11"]
  }
}

# --- A12: selection covers the instance by exact ARN; plan schedule is
# cron(0 0 * * ? *) (hour field "0", not "*" -> approximated as daily/24h). With the
# default 24-hour requirement this is an exact boundary match -> compliant.
resource "aws_instance" "pass_cron_daily_boundary" {
  attrs = {
    ami               = "ami-12345678"
    id                = "i-a12"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-a12"
  }
}

resource "aws_backup_plan" "plan_a12" {
  skip = true
  attrs = {
    id   = "plan-a12"
    arn  = "arn:aws:backup:us-east-1:123456789012:backup-plan:plan-a12"
    name = "plan-a12"
    rule = [{
      rule_name         = "rule-a12"
      target_vault_name = "vault-a12"
      schedule          = "cron(0 0 * * ? *)"
    }]
  }
}

resource "aws_backup_selection" "selection_a12" {
  skip = true
  attrs = {
    id           = "selection-a12"
    name         = "selection-a12"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    plan_id      = "plan-a12"
    resources    = ["arn:aws:ec2:us-east-1:123456789012:instance/i-a12"]
  }
}
