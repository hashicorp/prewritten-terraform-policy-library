# Copyright IBM Corp. 2026

policytest {
  targets = ["efs-recovery-point-compliance.policy.hcl"]
}

# Separate file: this scenario overrides the `resource_id` input, which
# requires its own `inputs {}` block (a file can declare only one). Uses
# resource_id = the matching EFS file system's id; all other inputs stay
# at their policy defaults.

inputs {
  efs-recovery-point-compliance-resource_id = "fs-00000014"
}

# Matches resourceId (filter passes), covered by resources = [arn] with a
# compliant plan (rate(1 hours) = 1h <= 24h required) -> pass.
resource "aws_efs_file_system" "resource_id_match_pass" {
  attrs = {
    id             = "fs-00000014"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000014"
    creation_token = "efs-resource-id-match"
    encrypted      = true
    tags           = {}
  }
}

resource "aws_backup_plan" "plan_for_resource_id_match" {
  skip = true
  attrs = {
    id   = "plan-for-resource-id-match"
    name = "plan-for-resource-id-match"
    rule = [{
      rule_name         = "rule-for-resource-id-match"
      target_vault_name = "vault-1"
      schedule          = "rate(1 hours)"
    }]
  }
}

resource "aws_backup_selection" "selection_for_resource_id_match" {
  skip = true
  attrs = {
    id           = "selection-for-resource-id-match"
    name         = "selection-for-resource-id-match"
    plan_id      = "plan-for-resource-id-match"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources    = ["arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000014"]
  }
}

# Does NOT match resourceId ("fs-00000014") -> filtered out entirely by
# matches_resource_id(), so this policy never evaluates it, even though it
# has no backup selection at all (which would otherwise be a violation) ->
# expect pass (the resource_policy is a no-op for it).
resource "aws_efs_file_system" "resource_id_no_match_skipped" {
  attrs = {
    id             = "fs-00000015"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000015"
    creation_token = "efs-resource-id-no-match"
    encrypted      = true
    tags           = {}
  }
}
