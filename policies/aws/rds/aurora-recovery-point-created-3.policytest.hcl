# Copyright IBM Corp. 2026

# Separate file: declares aws_backup_plan / aws_backup_selection resources matched via
# cluster_identifier substring and selection_tag (NOT via the "*" wildcard, so these
# scenarios can safely coexist together without cross-matching). Isolated from the
# default file (which must see zero backup plans/selections) and from the wildcard
# file (-2, where "*" would otherwise also cover these clusters). Uses default inputs.
policytest {
  targets = ["aurora-recovery-point-created.policy.hcl"]
}

resource "aws_backup_plan" "plan_4_noncompliant" {
  skip = true
  attrs = {
    name = "aurora-plan-4"
    rule = [{
      rule_name         = "every_two_days"
      target_vault_name = "Default"
      schedule          = "rate(2 days)"
    }]
  }
}

resource "aws_backup_plan" "plan_5_compliant" {
  skip = true
  attrs = {
    name = "aurora-plan-5"
    rule = [{
      rule_name         = "daily"
      target_vault_name = "Default"
      schedule          = "rate(1 day)"
    }]
  }
}

# References cluster-4 via cluster_identifier substring match in `resources`.
resource "aws_backup_selection" "selection_4_identifier_match" {
  skip = true
  attrs = {
    name          = "aurora-selection-4"
    iam_role_arn  = "arn:aws:iam::123456789012:role/aws-backup-role"
    plan_id       = "aurora-plan-4"
    resources     = ["aurora-cluster-4"]
    selection_tag = []
  }
}

# References cluster-5 via selection_tag matching the cluster's tags (STRINGEQUALS).
resource "aws_backup_selection" "selection_5_tag_match" {
  skip = true
  attrs = {
    name         = "aurora-selection-5"
    iam_role_arn = "arn:aws:iam::123456789012:role/aws-backup-role"
    plan_id      = "aurora-plan-5"
    resources    = []
    selection_tag = [{
      key   = "team"
      type  = "STRINGEQUALS"
      value = "payments"
    }]
  }
}

# Does not reference cluster-6 at all (neither resources nor selection_tag match).
resource "aws_backup_selection" "selection_6_no_match" {
  skip = true
  attrs = {
    name          = "aurora-selection-6"
    iam_role_arn  = "arn:aws:iam::123456789012:role/aws-backup-role"
    plan_id       = "aurora-plan-4"
    resources     = ["unrelated-cluster-xyz"]
    selection_tag = [{
      key   = "team"
      type  = "STRINGEQUALS"
      value = "other"
    }]
  }
}

# FAIL: backup_retention_period = 0; matched (via cluster_identifier substring) to a
# backup selection linked to a NON-compliant plan (rate(2 days) = 48h > required 24h).
resource "aws_rds_cluster" "fail_identifier_match_insufficient_plan_frequency" {
  expect_failure = true
  attrs = {
    cluster_identifier      = "aurora-cluster-4"
    engine                  = "aurora-mysql"
    backup_retention_period = 0
    tags                    = {}
    arn                     = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-4"
  }
}

# PASS: backup_retention_period = 0; matched (via selection_tag) to a backup selection
# linked to a compliant plan (rate(1 day) = 24h <= required 24h).
resource "aws_rds_cluster" "pass_tag_match_compliant_plan" {
  attrs = {
    cluster_identifier      = "aurora-cluster-5"
    engine                  = "aurora-postgresql"
    backup_retention_period = 0
    tags = {
      team = "payments"
    }
    arn = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-5"
  }
}

# FAIL: backup_retention_period = 0; a backup selection exists in the plan, but neither
# its resources list nor its selection_tag match this cluster, so it provides no cover.
resource "aws_rds_cluster" "fail_selection_present_no_match" {
  expect_failure = true
  attrs = {
    cluster_identifier      = "aurora-cluster-6"
    engine                  = "aurora-mysql"
    backup_retention_period = 0
    tags = {
      team = "finance"
    }
    arn = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-6"
  }
}
