# Copyright IBM Corp. 2026

# Separate file: assumes inputs.max_hours_since_backup = 12, with
# recovery_point_age_value/recovery_point_age_unit left at their defaults
# (1 / "days") so required window = max_hours_since_backup = 12 hours (see
# testcase_gen.md 4.2 case 1 -- distinct inputs{} values from other files).
policytest {
  targets = ["ebs-backup-recovery-point-created.policy.hcl"]
}

inputs {
  ebs-backup-recovery-point-created-max_hours_since_backup = 12
}

# Scenario 18: max_hours_since_backup overridden to 12, and the volume's
# backup plan rule has schedule = "rate(1 day)" (24h), exceeding the 12-hour
# window -> FAIL
resource "aws_backup_plan" "rate1day_plan" {
  attrs = {
    id   = "plan-hhh18"
    name = "hhh18-plan"
    rule = [
      {
        rule_name         = "hhh18-rule"
        target_vault_name = "default-vault"
        schedule          = "rate(1 day)"
      }
    ]
  }
}

resource "aws_backup_selection" "hhh18_selection" {
  attrs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    name         = "hhh18-selection"
    plan_id      = "plan-hhh18"
    resources    = ["*"]
  }
}

resource "aws_ebs_volume" "custom_max_hours_fail" {
  expect_failure = true
  attrs = {
    id                = "vol-hhh18"
    arn               = "arn:aws:ec2:us-east-1:123456789012:volume/vol-hhh18"
    availability_zone = "us-east-1a"
  }
}
