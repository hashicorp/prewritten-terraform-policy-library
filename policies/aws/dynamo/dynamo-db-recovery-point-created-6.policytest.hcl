# Copyright IBM Corp. 2026

# Separate file: assumes a different inputs {} block
# (resource_tags = "{\"Environment\":\"prod\"}"). A policytest file can
# declare only one inputs {} block, so this scenario set needs its own file.
# Uses default backup_period_days=1 etc. (required_hours=24).

policytest {
  targets = ["dynamo-db-recovery-point-created.policy.hcl"]
}

inputs {
  dynamo-db-recovery-point-created-resource_tags = "{\"Environment\":\"prod\"}"
}

# FAIL: table tags match resource_tags filter -> evaluated -> no AWS Backup
# coverage (PITR alone does not count).
resource "aws_dynamodb_table" "filtered_out_by_tags" {
  attrs = {
    name     = "wrong-tag-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = { Environment = "dev" }
  }
}

# FAIL: table tags match resource_tags filter -> evaluated -> non-compliant.
resource "aws_dynamodb_table" "matching_tags_noncompliant" {
  expect_failure = true
  attrs = {
    name     = "matching-tag-table-fail"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = { Environment = "prod" }
  }
}

# PASS: table tags match resource_tags filter -> evaluated -> compliant (PITR enabled).
resource "aws_dynamodb_table" "matching_tags_compliant" {
  expect_failure = true
  attrs = {
    name     = "matching-tag-table-pass"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = true }]
    tags = { Environment = "prod" }
  }
}
