# Copyright IBM Corp. 2026

policytest {
  targets = ["efs-recovery-point-compliance.policy.hcl"]
}

# Separate file: this scenario relies on a backup selection with
# resources = ["*"] (wildcard). core::getresources() returns every mock
# resource of a type declared anywhere in a file, so if this wildcard
# selection lived in the main file it would silently "cover" every other
# EFS file system in that file (none of which are meant to be covered by
# it). It must be isolated here. Uses the policy's default input values.

# Covered by a wildcard selection (resources = ["*"]), plan has a
# rate(12 hours) rule (frequency 12h) -> 12h <= 24h required -> pass.
resource "aws_efs_file_system" "wildcard_compliant_pass" {
  attrs = {
    id             = "fs-00000012"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000012"
    creation_token = "efs-wildcard-compliant"
    encrypted      = true
    tags           = {}
  }
}

resource "aws_backup_plan" "plan_rate_12h" {
  skip = true
  attrs = {
    id   = "plan-rate-12h"
    name = "plan-rate-12h"
    rule = [{
      rule_name         = "rule-rate-12h"
      target_vault_name = "vault-1"
      schedule          = "rate(12 hours)"
    }]
  }
}

resource "aws_backup_selection" "selection_wildcard_compliant" {
  skip = true
  attrs = {
    id           = "selection-wildcard-compliant"
    name         = "selection-wildcard-compliant"
    plan_id      = "plan-rate-12h"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources    = ["*"]
  }
}
