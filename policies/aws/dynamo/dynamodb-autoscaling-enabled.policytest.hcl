# Copyright IBM Corp. 2026

policytest {
  targets = [
    "dynamodb-autoscaling-enabled.policy.hcl"
  ]
}

# Test 1: PASS - On-demand (PAY_PER_REQUEST) table - The table is filtered out and does not require Application Auto Scaling targets.
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

# Test 2: PASS - PROVISIONED table with read and write autoscaling targets.
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

resource "aws_appautoscaling_target" "pass_provisioned_table_read" {
  skip = true
  attrs = {
    service_namespace  = "dynamodb"
    resource_id        = "table/provisioned-table"
    scalable_dimension = "dynamodb:table:ReadCapacityUnits"
    min_capacity       = 5
    max_capacity       = 100
  }
}

resource "aws_appautoscaling_target" "pass_provisioned_table_write" {
  skip = true
  attrs = {
    service_namespace  = "dynamodb"
    resource_id        = "table/provisioned-table"
    scalable_dimension = "dynamodb:table:WriteCapacityUnits"
    min_capacity       = 5
    max_capacity       = 100
  }
}

# Test 3: PASS - Default billing_mode resolves to PROVISIONED - Both read and write autoscaling targets are present.
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

resource "aws_appautoscaling_target" "pass_default_billing_read" {
  skip = true
  attrs = {
    service_namespace  = "dynamodb"
    resource_id        = "table/default-billing-table"
    scalable_dimension = "dynamodb:table:ReadCapacityUnits"
    min_capacity       = 5
    max_capacity       = 100
  }
}

resource "aws_appautoscaling_target" "pass_default_billing_write" {
  skip = true
  attrs = {
    service_namespace  = "dynamodb"
    resource_id        = "table/default-billing-table"
    scalable_dimension = "dynamodb:table:WriteCapacityUnits"
    min_capacity       = 5
    max_capacity       = 100
  }
}