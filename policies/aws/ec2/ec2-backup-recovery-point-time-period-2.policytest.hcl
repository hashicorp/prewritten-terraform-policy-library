# Copyright IBM Corp. 2026

# Separate file: assumes inputs.recovery_point_age_value = 1 and
# inputs.recovery_point_age_unit = "hours" (required_hours becomes 1), overriding the
# policy's "days" defaults. Isolated because it needs its own inputs {} block.

policytest {
  targets = ["ec2-backup-recovery-point-time-period.policy.hcl"]
}

inputs {
  ec2-backup-recovery-point-time-period-recovery_point_age_value = 1
  ec2-backup-recovery-point-time-period-recovery_point_age_unit  = "hours"
}

# PASS: plan schedule rate(1 hour) <= required 1 hour.
resource "aws_instance" "pass_required_one_hour" {
  attrs = {
    ami               = "ami-12345678"
    id                = "i-b1"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-b1"
  }
}

resource "aws_backup_plan" "plan_b1" {
  skip = true
  attrs = {
    id   = "plan-b1"
    arn  = "arn:aws:backup:us-east-1:123456789012:backup-plan:plan-b1"
    name = "plan-b1"
    rule = [{
      rule_name         = "rule-b1"
      target_vault_name = "vault-b1"
      schedule          = "rate(1 hour)"
    }]
  }
}

resource "aws_backup_selection" "selection_b1" {
  skip = true
  attrs = {
    id           = "selection-b1"
    name         = "selection-b1"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    plan_id      = "plan-b1"
    resources    = ["arn:aws:ec2:us-east-1:123456789012:instance/i-b1"]
  }
}

# FAIL: plan schedule rate(2 hours) > required 1 hour.
resource "aws_instance" "fail_required_one_hour" {
  expect_failure = true
  attrs = {
    ami               = "ami-12345678"
    id                = "i-b2"
    arn               = "arn:aws:ec2:us-east-1:123456789012:instance/i-b2"
  }
}

resource "aws_backup_plan" "plan_b2" {
  skip = true
  attrs = {
    id   = "plan-b2"
    arn  = "arn:aws:backup:us-east-1:123456789012:backup-plan:plan-b2"
    name = "plan-b2"
    rule = [{
      rule_name         = "rule-b2"
      target_vault_name = "vault-b2"
      schedule          = "rate(2 hours)"
    }]
  }
}

resource "aws_backup_selection" "selection_b2" {
  skip = true
  attrs = {
    id           = "selection-b2"
    name         = "selection-b2"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    plan_id      = "plan-b2"
    resources    = ["arn:aws:ec2:us-east-1:123456789012:instance/i-b2"]
  }
}
