# Copyright IBM Corp. 2026

policytest {
  targets = ["efs-recovery-point-compliance.policy.hcl"]
}

# Separate file: this scenario overrides `recovery_point_age_value` and
# `recovery_point_age_unit`, which requires its own `inputs {}` block (a
# file can declare only one). Uses recovery_point_age_value = 2 and
# recovery_point_age_unit = "hours" (=> required_hours = 2, since the unit
# is "hours": required_hours = recovery_point_age_value).

inputs {
  efs-recovery-point-compliance-recovery_point_age_value = 2
  efs-recovery-point-compliance-recovery_point_age_unit  = "hours"
}

# Covered by resources = [arn], plan has a rate(2 hours) rule (frequency
# 2h) -> 2h <= 2h required -> pass.
resource "aws_efs_file_system" "age_value_hours_compliant_pass" {
  attrs = {
    id             = "fs-00000018"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000018"
    creation_token = "efs-age-value-hours-compliant"
    encrypted      = true
    tags           = {}
  }
}

resource "aws_backup_plan" "plan_rate_2h" {
  skip = true
  attrs = {
    id   = "plan-rate-2h"
    name = "plan-rate-2h"
    rule = [{
      rule_name         = "rule-rate-2h"
      target_vault_name = "vault-1"
      schedule          = "rate(2 hours)"
    }]
  }
}

resource "aws_backup_selection" "selection_age_value_hours_compliant" {
  skip = true
  attrs = {
    id           = "selection-age-value-hours-compliant"
    name         = "selection-age-value-hours-compliant"
    plan_id      = "plan-rate-2h"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources    = ["arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000018"]
  }
}

# Covered by resources = [arn], plan has a rate(3 hours) rule (frequency
# 3h) -> 3h > 2h required -> violation.
resource "aws_efs_file_system" "age_value_hours_noncompliant_fail" {
  expect_failure = true
  attrs = {
    id             = "fs-00000019"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000019"
    creation_token = "efs-age-value-hours-noncompliant"
    encrypted      = true
    tags           = {}
  }
}

resource "aws_backup_plan" "plan_rate_3h" {
  skip = true
  attrs = {
    id   = "plan-rate-3h"
    name = "plan-rate-3h"
    rule = [{
      rule_name         = "rule-rate-3h"
      target_vault_name = "vault-1"
      schedule          = "rate(3 hours)"
    }]
  }
}

resource "aws_backup_selection" "selection_age_value_hours_noncompliant" {
  skip = true
  attrs = {
    id           = "selection-age-value-hours-noncompliant"
    name         = "selection-age-value-hours-noncompliant"
    plan_id      = "plan-rate-3h"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources    = ["arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000019"]
  }
}
