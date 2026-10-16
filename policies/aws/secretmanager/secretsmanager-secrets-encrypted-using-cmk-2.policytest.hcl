# Copyright IBM Corp. 2026

policytest {
  targets = ["secretsmanager-secrets-encrypted-using-cmk.policy.hcl"]
}

# Separate file: assumes inputs.allowed_kms_key_arns = a single allowlisted CMK ARN
# ("arn:aws:kms:us-east-1:123456789012:key/aaaa1111-aaaa-1111-aaaa-111111111111").
# A file can contain only one inputs {} block, so the allowlist scenarios (exact match,
# suffix/key-id match, and no-match) are isolated here, separate from the default
# (no allowlist) scenarios in secretsmanager-secrets-encrypted-using-cmk.policytest.hcl.
inputs {
  secretsmanager-secrets-encrypted-using-cmk-allowed_kms_key_arns = ["arn:aws:kms:us-east-1:123456789012:key/aaaa1111-aaaa-1111-aaaa-111111111111"]
}

# PASS: kms_key_id exactly matches the allowlisted ARN
resource "aws_secretsmanager_secret" "pass_matches_allowlist_exact" {
  attrs = {
    name        = "example-secret-allowlist-exact"
    description = "Secret using the exact allowlisted KMS key ARN"
    kms_key_id  = "arn:aws:kms:us-east-1:123456789012:key/aaaa1111-aaaa-1111-aaaa-111111111111"
  }
}

# PASS: kms_key_id is the bare key-id, which is the suffix of the allowlisted ARN
resource "aws_secretsmanager_secret" "pass_matches_allowlist_suffix" {
  attrs = {
    name        = "example-secret-allowlist-suffix"
    description = "Secret using the bare key id matching the allowlisted ARN's suffix"
    kms_key_id  = "aaaa1111-aaaa-1111-aaaa-111111111111"
  }
}

# FAIL: kms_key_id is a customer managed key ARN that is NOT in the allowlist
resource "aws_secretsmanager_secret" "fail_not_in_allowlist" {
  expect_failure = true
  attrs = {
    name        = "example-secret-not-allowlisted"
    description = "Secret using a CMK that is not in the allowlist"
    kms_key_id  = "arn:aws:kms:us-east-1:123456789012:key/bbbb2222-bbbb-2222-bbbb-222222222222"
  }
}
