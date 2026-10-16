# Copyright IBM Corp. 2026

# Separate file: assumes inputs.recovery_point_age_value = 2 and
# inputs.recovery_point_age_unit = "days" (required_hours becomes 48), overriding the
# policy's defaults (1 / "days", which maps to max_recovery_point_age_hours = 24).
# Isolated because it needs its own inputs {} block.

policytest {
  targets = ["ec2-backup-recovery-point-time-period.policy.hcl"]
}

inputs {
  ec2-backup-recovery-point-time-period-recovery_point_age_value = 2
  ec2-backup-recovery-point-time-period-recovery_point_age_unit  = "days"
}

# PASS: plan schedule rate(1 day) = 24h <= required 48h.
resource "aws_instance" "pass_required_48_hours" {
  attrs = {
    ami               = "ami-12345678"
    id                = "i-c1"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-c1"
  }
}

resource "aws_backup_plan" "plan_c1" {
  skip = true
  attrs = {
    id   = "plan-c1"
    arn  = "arn:aws:backup:us-east-1:123456789012:backup-plan:plan-c1"
    name = "plan-c1"
    rule = [{
      rule_name         = "rule-c1"
      target_vault_name = "vault-c1"
      schedule          = "rate(1 day)"
    }]
  }
}

resource "aws_backup_selection" "selection_c1" {
  skip = true
  attrs = {
    id           = "selection-c1"
    name         = "selection-c1"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    plan_id      = "plan-c1"
    resources    = ["arn:aws:ec2:us-east-1:123456789012:instance/i-c1"]
  }
}

# FAIL: plan schedule rate(3 days) = 72h > required 48h.
resource "aws_instance" "fail_required_48_hours" {
  expect_failure = true
  attrs = {
    ami               = "ami-12345678"
    id                = "i-c2"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-c2"
  }
}

resource "aws_backup_plan" "plan_c2" {
  skip = true
  attrs = {
    id   = "plan-c2"
    arn  = "arn:aws:backup:us-east-1:123456789012:backup-plan:plan-c2"
    name = "plan-c2"
    rule = [{
      rule_name         = "rule-c2"
      target_vault_name = "vault-c2"
      schedule          = "rate(3 days)"
    }]
  }
}

resource "aws_backup_selection" "selection_c2" {
  skip = true
  attrs = {
    id           = "selection-c2"
    name         = "selection-c2"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    plan_id      = "plan-c2"
    resources    = ["arn:aws:ec2:us-east-1:123456789012:instance/i-c2"]
  }
}
