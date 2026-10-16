# Copyright IBM Corp. 2026

policytest {
  targets = ["dynamo-db-table-encrypted-kms.policy.hcl"]
}

# Separate file: assumes inputs.kms_key_arns is overridden to a non-empty
# allowlist (two specific KMS key ARNs). This cannot be combined with the
# default-inputs file because a single .policytest.hcl file can declare only
# one `inputs {}` block, and these scenarios require a different value than
# the policy's default `kms_key_arns = []`.
# Covers GWT scenarios 5-7.

inputs {
  dynamo-db-table-encrypted-kms-kms_key_arns = [
    "arn:aws:kms:us-east-1:123456789012:key/allowed-key-1",
    "arn:aws:kms:us-east-1:123456789012:key/allowed-key-2",
  ]
}

# PASS: server_side_encryption.enabled = true, kms_key_arn matches one of the
# allowed keys in the restricted list -> compliant.
resource "aws_dynamodb_table" "pass_key_in_allowed_list" {
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

# FAIL: server_side_encryption.enabled = true but kms_key_arn is empty string
# (using the default KMS-managed key). The restricted allowlist is non-empty,
# so the default key is not an explicitly allowed key -> non-compliant.
resource "aws_dynamodb_table" "fail_default_key_restricted" {
  expect_failure = true
  attrs = {
    name         = "restricted-table-default-key"
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
        kms_key_arn = ""
      }
    ]
  }
}

# FAIL: server_side_encryption.enabled = true, kms_key_arn set to a key that
# is NOT in the allowed list -> non-compliant.
resource "aws_dynamodb_table" "fail_key_not_allowed" {
  expect_failure = true
  attrs = {
    name         = "restricted-table-wrong-key"
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
        kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/not-allowed-key"
      }
    ]
  }
}
