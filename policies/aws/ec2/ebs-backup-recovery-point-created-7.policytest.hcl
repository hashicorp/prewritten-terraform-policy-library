# Copyright IBM Corp. 2026

# Separate file: assumes inputs.recovery_point_age_value = 3 and
# inputs.recovery_point_age_unit = "days" (required window = 72 hours; see
# testcase_gen.md 4.2 case 1 -- distinct inputs{} values from other files).
policytest {
  targets = ["ebs-backup-recovery-point-created.policy.hcl"]
}

inputs {
  ebs-backup-recovery-point-created-recovery_point_age_value = 3
  ebs-backup-recovery-point-created-recovery_point_age_unit  = "days"
}

# Scenario 17: required window = 72 hours, and the volume's backup plan rule
# has schedule = "rate(2 days)" (48h), within the 72-hour window -> PASS
resource "aws_backup_plan" "rate2days_plan" {
  attrs = {
    id   = "plan-ggg17"
    name = "ggg17-plan"
    rule = [
      {
        rule_name         = "ggg17-rule"
        target_vault_name = "default-vault"
        schedule          = "rate(2 days)"
      }
    ]
  }
}

resource "aws_backup_selection" "ggg17_selection" {
  attrs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    name         = "ggg17-selection"
    plan_id      = "plan-ggg17"
    resources    = ["*"]
  }
}

resource "aws_ebs_volume" "custom_window_days_pass" {
  attrs = {
    id                = "vol-ggg17"
    arn               = "arn:aws:ec2:us-east-1:123456789012:volume/vol-ggg17"
    availability_zone = "us-east-1a"
  }
}
