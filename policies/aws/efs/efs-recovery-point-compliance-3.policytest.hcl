# Copyright IBM Corp. 2026

policytest {
  targets = ["efs-recovery-point-compliance.policy.hcl"]
}

# Separate file: this scenario relies on a wildcard not_resources exclusion
# (resources = ["*"], not_resources = [<this EFS arn>]). If this selection
# lived alongside any other non-excluding wildcard selection (such as the
# one in -2.policytest.hcl), core::getresources() would make that other
# selection cover this EFS resource too (since its wildcard `resources`
# list has no matching exclusion), masking the exclusion this scenario is
# meant to exercise. It must be isolated here. Uses the policy's default
# input values.

# Selection matches via resources = ["*"], but this EFS file system's ARN
# is explicitly excluded via not_resources -> selection does not cover it,
# even though its plan is otherwise compliant -> violation.
resource "aws_efs_file_system" "not_resources_excluded_fail" {
  expect_failure = true
  attrs = {
    id             = "fs-00000013"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000013"
    creation_token = "efs-not-resources-excluded"
    encrypted      = true
    tags           = {}
  }
}

resource "aws_backup_plan" "plan_for_exclusion" {
  skip = true
  attrs = {
    id   = "plan-for-exclusion"
    name = "plan-for-exclusion"
    rule = [{
      rule_name         = "rule-for-exclusion"
      target_vault_name = "vault-1"
      schedule          = "rate(1 hours)"
    }]
  }
}

resource "aws_backup_selection" "selection_excludes_target" {
  skip = true
  attrs = {
    id            = "selection-excludes-target"
    name          = "selection-excludes-target"
    plan_id       = "plan-for-exclusion"
    iam_role_arn  = "arn:aws:iam::123456789012:role/backup-role"
    resources     = ["*"]
    not_resources = ["arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000013"]
  }
}
