# Copyright IBM Corp. 2026

policytest {
  targets = [
    "dynamodb-autoscaling-enabled.policy.hcl"
  ]
}

# --------------- PASS cases ---------------

# Test 1: PASS - On-demand (PAY_PER_REQUEST) table — filtered out, always compliant
resource "aws_dynamodb_table" "pass_on_demand_table" {
  attrs = {
    name         = "on-demand-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "id"
    attribute = [
      { name = "id", type = "S" }
    ]
  }
}

# Test 2: PASS - PROVISIONED table with valid input parameters
resource "aws_dynamodb_table" "pass_provisioned_table" {
  attrs = {
    name           = "provisioned-table"
    billing_mode   = "PROVISIONED"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "id"
    attribute = [
      { name = "id", type = "S" }
    ]
  }
}

# Test 3: PASS - Default billing_mode (resolves to PROVISIONED), no input overrides
resource "aws_dynamodb_table" "pass_default_billing" {
  attrs = {
    name           = "default-billing-table"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "id"
    attribute = [
      { name = "id", type = "S" }
    ]
  }
}
