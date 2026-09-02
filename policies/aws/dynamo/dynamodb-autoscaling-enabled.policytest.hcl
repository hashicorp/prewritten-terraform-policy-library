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

# Test 4: FAIL - PROVISIONED table with no autoscaling targets at all.
resource "aws_dynamodb_table" "fail_no_autoscaling_targets" {
  expect_failure = true
  attrs = {
    name           = "no-autoscaling-table"
    billing_mode   = "PROVISIONED"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "id"
    attribute = [
      { name = "id", type = "S" }
    ]
  }
}

# Test 5: FAIL - PROVISIONED table with only a read autoscaling target (missing write).
resource "aws_dynamodb_table" "fail_missing_write_target" {
  expect_failure = true
  attrs = {
    name           = "missing-write-target-table"
    billing_mode   = "PROVISIONED"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "id"
    attribute = [
      { name = "id", type = "S" }
    ]
  }
}

resource "aws_appautoscaling_target" "fail_missing_write_target_read" {
  skip = true
  attrs = {
    service_namespace  = "dynamodb"
    resource_id        = "table/missing-write-target-table"
    scalable_dimension = "dynamodb:table:ReadCapacityUnits"
    min_capacity       = 5
    max_capacity       = 100
  }
}

# Test 6: FAIL - PROVISIONED table with only a write autoscaling target (missing read).
resource "aws_dynamodb_table" "fail_missing_read_target" {
  expect_failure = true
  attrs = {
    name           = "missing-read-target-table"
    billing_mode   = "PROVISIONED"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "id"
    attribute = [
      { name = "id", type = "S" }
    ]
  }
}

resource "aws_appautoscaling_target" "fail_missing_read_target_write" {
  skip = true
  attrs = {
    service_namespace  = "dynamodb"
    resource_id        = "table/missing-read-target-table"
    scalable_dimension = "dynamodb:table:WriteCapacityUnits"
    min_capacity       = 5
    max_capacity       = 100
  }
}

# Test 7: PASS - PROVISIONED table with both read and write autoscaling targets and a
# TargetTrackingScaling policy on each dimension.
resource "aws_dynamodb_table" "pass_with_autoscaling_policies" {
  attrs = {
    name           = "full-autoscaling-table"
    billing_mode   = "PROVISIONED"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "id"
    attribute = [
      { name = "id", type = "S" }
    ]
  }
}

resource "aws_appautoscaling_target" "pass_with_autoscaling_policies_read" {
  skip = true
  attrs = {
    service_namespace  = "dynamodb"
    resource_id        = "table/full-autoscaling-table"
    scalable_dimension = "dynamodb:table:ReadCapacityUnits"
    min_capacity       = 5
    max_capacity       = 100
  }
}

resource "aws_appautoscaling_target" "pass_with_autoscaling_policies_write" {
  skip = true
  attrs = {
    service_namespace  = "dynamodb"
    resource_id        = "table/full-autoscaling-table"
    scalable_dimension = "dynamodb:table:WriteCapacityUnits"
    min_capacity       = 5
    max_capacity       = 100
  }
}

resource "aws_appautoscaling_policy" "pass_with_autoscaling_policies_read_policy" {
  skip = true
  attrs = {
    service_namespace  = "dynamodb"
    resource_id        = "table/full-autoscaling-table"
    scalable_dimension = "dynamodb:table:ReadCapacityUnits"
    policy_type        = "TargetTrackingScaling"
    target_tracking_scaling_policy_configuration = [
      {
        target_value = 70
      }
    ]
  }
}

resource "aws_appautoscaling_policy" "pass_with_autoscaling_policies_write_policy" {
  skip = true
  attrs = {
    service_namespace  = "dynamodb"
    resource_id        = "table/full-autoscaling-table"
    scalable_dimension = "dynamodb:table:WriteCapacityUnits"
    policy_type        = "TargetTrackingScaling"
    target_tracking_scaling_policy_configuration = [
      {
        target_value = 70
      }
    ]
  }
}
