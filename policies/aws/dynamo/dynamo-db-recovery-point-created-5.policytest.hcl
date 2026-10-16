# Copyright IBM Corp. 2026

# Separate file: assumes a different inputs {} block (resourceId=
# "specific-table"). A policytest file can declare only one inputs {} block,
# so this scenario set needs its own file. Uses default backup_period_days=1
# etc. (required_hours=24).

policytest {
  targets = ["dynamo-db-recovery-point-created.policy.hcl"]
}

inputs {
  dynamo-db-recovery-point-created-resourceId = "specific-table"
}

# PASS: table name does not match resourceId filter -> not evaluated -> passes
# trivially even though it is non-compliant (PITR disabled, no coverage).
resource "aws_dynamodb_table" "filtered_out_by_id" {
  attrs = {
    name     = "other-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
  }
}

# FAIL: table name matches resourceId filter -> evaluated -> non-compliant.
resource "aws_dynamodb_table" "matching_id_noncompliant" {
  expect_failure = true
  attrs = {
    name     = "specific-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = false }]
    tags = {}
  }
}

# PASS: table name matches resourceId filter -> evaluated -> compliant (PITR enabled).
resource "aws_dynamodb_table" "matching_id_compliant" {
  attrs = {
    name     = "specific-table"
    hash_key = "id"
    attribute = [{ name = "id", type = "S" }]
    billing_mode = "PAY_PER_REQUEST"
    point_in_time_recovery = [{ enabled = true }]
    tags = {}
  }
}
