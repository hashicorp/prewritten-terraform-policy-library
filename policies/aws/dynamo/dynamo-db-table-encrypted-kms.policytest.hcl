# Copyright IBM Corp. 2026

policytest {
  targets = ["dynamo-db-table-encrypted-kms.policy.hcl"]
}

# PASS: default key no restriction
resource "aws_dynamodb_table" "pass_default_key_no_restriction" {
  attrs = {
    name         = "orders-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "id"
    attribute = [
      {
        name = "id"
        type = "S"
      }
    ]
    server_side_encryption = [
      {
        enabled = true
      }
    ]
  }
}

# PASS: server_side_encryption.enabled = true with an explicit kms_key_arn
resource "aws_dynamodb_table" "pass_explicit_key_no_restriction" {
  attrs = {
    name         = "orders-table-custom-key"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "id"
    attribute = [
      {
        name = "id"
        type = "S"
      }
    ]
    server_side_encryption = [
      {
        enabled     = true
        kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/custom-key-id"
      }
    ]
  }
}

# PASS: null kms key no restriction
resource "aws_dynamodb_table" "pass_null_kms_key_no_restriction" {
  attrs = {
    name         = "orders-table-null-key"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "id"
    attribute = [
      {
        name = "id"
        type = "S"
      }
    ]
    server_side_encryption = [
      {
        enabled     = true
        kms_key_arn = null
      }
    ]
  }
}

# FAIL: no server_side_encryption block at all (attribute omitted entirely)
resource "aws_dynamodb_table" "fail_missing_sse_block" {
  expect_failure = true
  attrs = {
    name         = "unencrypted-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "id"
    attribute = [
      {
        name = "id"
        type = "S"
      }
    ]
  }
}

# FAIL: server_side_encryption present but as an empty list (edge case for the has_sse computation)
resource "aws_dynamodb_table" "fail_empty_sse_list" {
  expect_failure = true
  attrs = {
    name         = "empty-sse-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "id"
    attribute = [
      {
        name = "id"
        type = "S"
      }
    ]
    server_side_encryption = []
  }
}

# FAIL: server_side_encryption.enabled = false
resource "aws_dynamodb_table" "fail_sse_disabled" {
  expect_failure = true
  attrs = {
    name         = "disabled-sse-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "id"
    attribute = [
      {
        name = "id"
        type = "S"
      }
    ]
    server_side_encryption = [
      {
        enabled     = false
        kms_key_arn = null
      }
    ]
  }
}

# FAIL: server_side_encryption.enabled explicitly null (two-step normalization treats explicit null the same as false)
resource "aws_dynamodb_table" "fail_enabled_null" {
  expect_failure = true
  attrs = {
    name         = "null-enabled-table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "id"
    attribute = [
      {
        name = "id"
        type = "S"
      }
    ]
    server_side_encryption = [
      {
        enabled     = null
        kms_key_arn = null
      }
    ]
  }
}

# PASS: key in allowed list
resource "aws_dynamodb_table" "pass_key_in_allowed_list_f2" {
  attrs = {
    name         = "restricted-table-allowed-key"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "id"
    attribute = [
      {
        name = "id"
        type = "S"
      }
    ]
    server_side_encryption = [
      {
        enabled     = true
        kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/allowed-key-1"
      }
    ]
  }
}
