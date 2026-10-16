# Copyright IBM Corp. 2026

policytest {
  targets = ["secretsmanager-secrets-encrypted-using-cmk.policy.hcl"]
}

# Default inputs file: no inputs {} block, so input.allowed_kms_key_arns uses its default
# of [] (no allowlist configured). Covers the "missing / AWS managed key" violation cases
# and the pass case where any customer managed key is accepted (no allowlist restriction).

# FAIL: kms_key_id attribute entirely omitted -> defaults to AWS managed key
resource "aws_secretsmanager_secret" "fail_missing_kms_key_id" {
  expect_failure = true
  attrs = {
    name        = "example-secret-missing-kms"
    description = "Secret without kms_key_id"
  }
}

# FAIL: kms_key_id explicitly null -> same as missing
resource "aws_secretsmanager_secret" "fail_null_kms_key_id" {
  expect_failure = true
  attrs = {
    name        = "example-secret-null-kms"
    description = "Secret with kms_key_id explicitly null"
    kms_key_id  = null
  }
}

# FAIL: kms_key_id is an empty string
resource "aws_secretsmanager_secret" "fail_empty_kms_key_id" {
  expect_failure = true
  attrs = {
    name        = "example-secret-empty-kms"
    description = "Secret with kms_key_id as empty string"
    kms_key_id  = ""
  }
}

# FAIL: kms_key_id uses the AWS managed key alias
resource "aws_secretsmanager_secret" "fail_aws_managed_alias" {
  expect_failure = true
  attrs = {
    name        = "example-secret-managed-alias"
    description = "Secret using AWS managed key alias"
    kms_key_id  = "alias/aws/secretsmanager"
  }
}

# FAIL: kms_key_id uses the AWS managed key bare name
resource "aws_secretsmanager_secret" "fail_aws_managed_name" {
  expect_failure = true
  attrs = {
    name        = "example-secret-managed-name"
    description = "Secret using AWS managed key bare name"
    kms_key_id  = "aws/secretsmanager"
  }
}

# FAIL: kms_key_id is prefixed with the AWS managed key alias (regional variant)
resource "aws_secretsmanager_secret" "fail_aws_managed_alias_prefix" {
  expect_failure = true
  attrs = {
    name        = "example-secret-managed-prefix"
    description = "Secret using a value prefixed with the AWS managed key alias"
    kms_key_id  = "alias/aws/secretsmanager-us-east-1"
  }
}

# PASS: kms_key_id is a customer managed KMS key ARN; no allowlist configured, so any CMK is allowed
resource "aws_secretsmanager_secret" "pass_customer_managed_key_no_allowlist" {
  attrs = {
    name        = "example-secret-cmk"
    description = "Secret using a customer managed KMS key"
    kms_key_id  = "arn:aws:kms:us-east-1:123456789012:key/aaaa1111-aaaa-1111-aaaa-111111111111"
  }
}

# ---- Cases merged from secretsmanager-secrets-encrypted-using-cmk-2.policytest.hcl ----

# PASS: kms_key_id exactly matches the allowlisted ARN
resource "aws_secretsmanager_secret" "pass_matches_allowlist_exact_f2" {
  attrs = {
    name        = "example-secret-allowlist-exact"
    description = "Secret using the exact allowlisted KMS key ARN"
    kms_key_id  = "arn:aws:kms:us-east-1:123456789012:key/aaaa1111-aaaa-1111-aaaa-111111111111"
  }
}

# PASS: kms_key_id is the bare key-id, which is the suffix of the allowlisted ARN
resource "aws_secretsmanager_secret" "pass_matches_allowlist_suffix_f2" {
  attrs = {
    name        = "example-secret-allowlist-suffix"
    description = "Secret using the bare key id matching the allowlisted ARN's suffix"
    kms_key_id  = "aaaa1111-aaaa-1111-aaaa-111111111111"
  }
}

