# Copyright IBM Corp. 2026

policytest {
  targets = ["aurora-recovery-point-created.policy.hcl"]
}

# Default inputs file. No aws_backup_plan / aws_backup_selection resources are declared
# in this file so that core::getresources() reliably returns zero results for clusters
# that rely solely on the automated-backup path (see testing-guide.md "core::getresources()
# sees ALL resources in the test file"). Scenarios that need a compliant/non-compliant
# AWS Backup plan live in separate files (-2, -3).

# PASS: Aurora cluster with sufficient backup_retention_period, no AWS Backup plan needed.
resource "aws_rds_cluster" "pass_backup_retention_sufficient" {
  attrs = {
    cluster_identifier      = "aurora-cluster-1"
    engine                  = "aurora-mysql"
    backup_retention_period = 1
    tags                    = {}
    arn                     = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-1"
  }
}

# FAIL: Aurora cluster with backup_retention_period = 0 and no AWS Backup plan at all.
resource "aws_rds_cluster" "fail_backup_retention_insufficient_no_plan" {
  expect_failure = true
  attrs = {
    cluster_identifier      = "aurora-cluster-2"
    engine                  = "aurora-postgresql"
    backup_retention_period = 0
    tags                    = {}
    arn                     = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-2"
  }
}

# PASS (not evaluated): non-Aurora engine is excluded by the policy's filter, even
# though backup_retention_period is 0.
resource "aws_rds_cluster" "skip_non_aurora_engine" {
  attrs = {
    cluster_identifier      = "mysql-cluster-7"
    engine                  = "mysql"
    backup_retention_period = 0
    tags                    = {}
    arn                     = "arn:aws:rds:us-east-1:123456789012:cluster:mysql-cluster-7"
  }
}

# FAIL: backup_retention_period attribute entirely omitted (defaults to 0 via core::try()).
resource "aws_rds_cluster" "fail_missing_backup_retention_attribute" {
  expect_failure = true
  attrs = {
    cluster_identifier = "aurora-cluster-11"
    engine              = "aurora-mysql"
    tags                = {}
    arn                 = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-11"
    # backup_retention_period intentionally omitted
  }
}

# FAIL: tags explicitly set to null (two-step normalization to {}) combined with
# insufficient backup_retention_period and no AWS Backup plan. Confirms the policy
# does not crash when tags is explicitly null.
resource "aws_rds_cluster" "fail_tags_null_no_plan" {
  expect_failure = true
  attrs = {
    cluster_identifier      = "aurora-cluster-12"
    engine                  = "aurora-mysql"
    backup_retention_period = 0
    tags                    = null
    arn                     = "arn:aws:rds:us-east-1:123456789012:cluster:aurora-cluster-12"
  }
}
