# Copyright IBM Corp. 2026

# Separate file: isolates the "*" wildcard aws_backup_selection scenario. A selection
# with resources = ["*"] matches EVERY aws_rds_cluster present in this test file (see
# the policy's matching_selections logic), so this file intentionally contains only
# the single cluster this scenario is about. Uses default inputs.
policytest {
  targets = ["aurora-recovery-point-created.policy.hcl"]
}

resource "aws_backup_plan" "plan_3_compliant" {
  skip = true
  attrs = {
    name = "aurora-plan-3"
    rule = [{
      rule_name         = "daily"
      target_vault_name = "Default"
      schedule          = "rate(1 day)"
    }]
  }
}

resource "aws_backup_selection" "selection_3_wildcard" {
  skip = true
  attrs = {
    name          = "aurora-selection-3"
    iam_role_arn  = "arn:aws:iam::123456789012:role/aws-backup-role"
    plan_id       = "aurora-plan-3"
    resources     = ["*"]
    selection_tag = []
  }
}

# PASS: backup_retention_period = 0, but the cluster is covered by a wildcard backup
# selection ("*") linked to a compliant backup plan (rate(1 day) = 24h <= required 24h).
resource "aws_rds_cluster" "pass_wildcard_selection_compliant_plan" {
  attrs = {
    cluster_identifier      = "aurora-cluster-3"
    engine                  = "aurora-mysql"
    backup_retention_period = 0
    tags                    = {}
    arn                     = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-3"
  }
}
