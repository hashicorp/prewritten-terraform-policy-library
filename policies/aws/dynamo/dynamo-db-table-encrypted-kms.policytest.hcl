# Copyright IBM Corp. 2026

policytest {
  targets = ["dynamo-db-table-encrypted-kms.policy.hcl"]
}

# Default inputs file: assumes no `inputs {}` block is present, so
# input.kms_key_arns uses its policy default of [] (no KMS key restriction).
# Covers GWT scenarios 1-4 plus edge cases that are only meaningful when no
# allowed-key restriction is configured.

# PASS: server_side_encryption.enabled = true, kms_key_arn omitted (uses the
# default AWS-managed DynamoDB key). No restriction configured -> compliant.
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

# PASS: server_side_encryption.enabled = true with an explicit kms_key_arn.
# No restriction configured -> compliant.
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

# PASS: server_side_encryption.enabled = true, kms_key_arn explicitly null
# (two-step normalization in the policy treats explicit null the same as
# omitted -> "" default key). No restriction configured -> compliant.
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

# FAIL: no server_side_encryption block at all (attribute omitted entirely).
# Table has no KMS encryption configured -> non-compliant.
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

# FAIL: server_side_encryption present but as an empty list (edge case for
# the has_sse computation) -> treated the same as missing -> non-compliant.
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

# FAIL: server_side_encryption.enabled = false -> encryption at rest uses the
# AWS-owned key, not a KMS CMK -> non-compliant.
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

# FAIL: server_side_encryption.enabled explicitly null (two-step
# normalization treats explicit null the same as false) -> non-compliant.
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

# ---- Cases merged from dynamo-db-table-encrypted-kms-2.policytest.hcl ----

# PASS: server_side_encryption.enabled = true, kms_key_arn matches one of the
# allowed keys in the restricted list -> compliant.
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


