# Copyright IBM Corp. 2026

# Separate file: assumes inputs.recovery_point_age_value = 2 and
# inputs.recovery_point_age_unit = "hours" (required window = 2 hours; see
# testcase_gen.md 4.2 case 1 -- distinct inputs{} values from other files).
policytest {
  targets = ["ebs-backup-recovery-point-created.policy.hcl"]
}

inputs {
  ebs-backup-recovery-point-created-recovery_point_age_value = 2
  ebs-backup-recovery-point-created-recovery_point_age_unit  = "hours"
}

# Scenario 16: required window = 2 hours, and the volume's backup plan rule
# has schedule = "rate(5 hours)" (5h), exceeding the 2-hour window -> FAIL
resource "aws_backup_plan" "rate5h_plan" {
  attrs = {
    id   = "plan-fff16"
    name = "fff16-plan"
    rule = [
      {
        rule_name         = "fff16-rule"
        target_vault_name = "default-vault"
        schedule          = "rate(5 hours)"
      }
    ]
  }
}

resource "aws_backup_selection" "fff16_selection" {
  attrs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    name         = "fff16-selection"
    plan_id      = "plan-fff16"
    resources    = ["*"]
  }
}

resource "aws_ebs_volume" "custom_window_hours_fail" {
  expect_failure = true
  attrs = {
    id                = "vol-fff16"
    arn               = "arn:aws:ec2:us-east-1:123456789012:volume/vol-fff16"
    availability_zone = "us-east-1a"
  }
}
