# Copyright IBM Corp. 2026

policytest {
  targets = ["efs-recovery-point-compliance.policy.hcl"]
}

# Separate file: this scenario overrides `recovery_point_age_value` and
# `recovery_point_age_unit`, which requires its own `inputs {}` block (a
# file can declare only one). Uses recovery_point_age_value = 2 and
# recovery_point_age_unit = "days" (=> required_hours = 48, since the unit
# is "days": required_hours = recovery_point_age_value * 24).

inputs {
  efs-recovery-point-compliance-recovery_point_age_value = 2
  efs-recovery-point-compliance-recovery_point_age_unit  = "days"
}

# Covered by resources = [arn], plan has a rate(2 days) rule (frequency
# 48h) -> 48h <= 48h required -> pass.
resource "aws_efs_file_system" "age_value_days_compliant_pass" {
  attrs = {
    id             = "fs-00000020"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000020"
    creation_token = "efs-age-value-days-compliant"
    encrypted      = true
    tags           = {}
  }
}

resource "aws_backup_plan" "plan_rate_48h" {
  skip = true
  attrs = {
    id   = "plan-rate-48h-v2"
    name = "plan-rate-48h-v2"
    rule = [{
      rule_name         = "rule-rate-48h-v2"
      target_vault_name = "vault-1"
      schedule          = "rate(2 days)"
    }]
  }
}

resource "aws_backup_selection" "selection_age_value_days_compliant" {
  skip = true
  attrs = {
    id           = "selection-age-value-days-compliant"
    name         = "selection-age-value-days-compliant"
    plan_id      = "plan-rate-48h-v2"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources    = ["arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000020"]
  }
}

# Covered by resources = [arn], plan has a rate(3 days) rule (frequency
# 72h) -> 72h > 48h required -> violation.
resource "aws_efs_file_system" "age_value_days_noncompliant_fail" {
  expect_failure = true
  attrs = {
    id             = "fs-00000021"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000021"
    creation_token = "efs-age-value-days-noncompliant"
    encrypted      = true
    tags           = {}
  }
}

resource "aws_backup_plan" "plan_rate_72h" {
  skip = true
  attrs = {
    id   = "plan-rate-72h"
    name = "plan-rate-72h"
    rule = [{
      rule_name         = "rule-rate-72h"
      target_vault_name = "vault-1"
      schedule          = "rate(3 days)"
    }]
  }
}

resource "aws_backup_selection" "selection_age_value_days_noncompliant" {
  skip = true
  attrs = {
    id           = "selection-age-value-days-noncompliant"
    name         = "selection-age-value-days-noncompliant"
    plan_id      = "plan-rate-72h"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources    = ["arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000021"]
  }
}
