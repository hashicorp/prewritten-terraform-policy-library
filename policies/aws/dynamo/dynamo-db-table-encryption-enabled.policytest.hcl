# Copyright IBM Corp. 2026

policytest {
  targets = ["dynamo-db-table-encryption-enabled.policy.hcl"]
}

# PASS: no server_side_encryption block configured at all.
# DynamoDB applies its default AWS-owned-key encryption, which is compliant.
resource "aws_dynamodb_table" "pass_default_encryption" {
  attrs = {
    name           = "default-encryption-table"
    billing_mode   = "PROVISIONED"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "id"
    attribute = [
      {
        name = "id"
        type = "S"
      }
    ]
  }
}

# PASS: server_side_encryption block present with enabled explicitly set to true.
resource "aws_dynamodb_table" "pass_enabled_true" {
  attrs = {
    name           = "encrypted-table"
    billing_mode   = "PROVISIONED"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "id"
    attribute = [
      {
        name = "id"
        type = "S"
      }
    ]
    server_side_encryption = [
      {
        enabled     = true
        kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef"
      }
    ]
  }
}

# PASS (AWS owned key): server_side_encryption block present but enabled explicitly set to false.
resource "aws_dynamodb_table" "pass_enabled_false" {
  attrs = {
    name           = "unencrypted-table"
    billing_mode   = "PROVISIONED"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "id"
    attribute = [
      {
        name = "id"
        type = "S"
      }
    ]
    server_side_encryption = [
      {
        enabled = false
      }
    ]
  }
}

# PASS (AWS owned key): server_side_encryption block present but the 'enabled' attribute is
# entirely omitted. core::try() falls back to null -> normalized to false ->
# non-compliant, since a configured server_side_encryption block must have
# an explicit enabled = true.
resource "aws_dynamodb_table" "pass_enabled_missing" {
  attrs = {
    name           = "missing-enabled-table"
    billing_mode   = "PROVISIONED"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "id"
    attribute = [
      {
        name = "id"
        type = "S"
      }
    ]
    server_side_encryption = [
      {
        kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/abcd1234-a123-456a-a12b-a123b4cd56ef"
      }
    ]
  }
}

# PASS (AWS owned key): server_side_encryption block present with 'enabled' explicitly set to null.
# core::try(attrs.field, default) returns null (not the default) when the key is
# explicitly null, so the two-step normalization treats this as false -> non-compliant.
resource "aws_dynamodb_table" "pass_enabled_null" {
  attrs = {
    name           = "null-enabled-table"
    billing_mode   = "PROVISIONED"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "id"
    attribute = [
      {
        name = "id"
        type = "S"
      }
    ]
    server_side_encryption = [
      {
        enabled = null
      }
    ]
  }
}
