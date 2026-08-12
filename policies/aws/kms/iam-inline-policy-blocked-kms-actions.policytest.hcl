# Copyright IBM Corp. 2026

policytest {
  targets = ["iam-inline-policy-blocked-kms-actions.policy.hcl"]
}

# PASS: Statement with only non-blocked KMS actions
resource "aws_iam_policy_document" "pass_non_blocked_kms_actions" {
  attrs = {
    statement = [
      {
        sid       = "AllowNonBlockedKms"
        effect    = "Allow"
        actions   = ["kms:Encrypt", "kms:GenerateDataKey"]
        resources = ["*"]
      }
    ]
  }
}

# PASS: Multiple statements, all with compliant actions only
resource "aws_iam_policy_document" "pass_multiple_compliant_statements" {
  attrs = {
    statement = [
      {
        sid       = "AllowKmsEncrypt"
        effect    = "Allow"
        actions   = ["kms:Encrypt", "kms:GenerateDataKey"]
        resources = ["arn:aws:kms:us-east-1:123456789012:key/12345"]
      },
      {
        sid       = "AllowS3"
        effect    = "Allow"
        actions   = ["s3:GetObject", "s3:PutObject"]
        resources = ["arn:aws:s3:::my-bucket/*"]
      }
    ]
  }
}

# PASS: Statement with empty actions list
resource "aws_iam_policy_document" "pass_empty_actions" {
  attrs = {
    statement = [
      {
        sid       = "EmptyActions"
        effect    = "Allow"
        actions   = []
        resources = ["*"]
      }
    ]
  }
}

# PASS: No statements (empty statement list)
resource "aws_iam_policy_document" "pass_no_statements" {
  attrs = {
    statement = []
  }
}

# PASS: Missing statement attribute entirely
resource "aws_iam_policy_document" "pass_missing_statement_attr" {
  attrs = {
    version = "2012-10-17"
  }
}

# PASS: Statement with missing actions attribute
resource "aws_iam_policy_document" "pass_missing_actions_attr" {
  attrs = {
    statement = [
      {
        sid       = "MissingActions"
        effect    = "Allow"
        resources = ["*"]
      }
    ]
  }
}

# FAIL: Statement with kms:Decrypt action
resource "aws_iam_policy_document" "fail_kms_decrypt" {
  expect_failure = true
  attrs = {
    statement = [
      {
        sid       = "AllowKmsDecrypt"
        effect    = "Allow"
        actions   = ["kms:Decrypt"]
        resources = ["*"]
      }
    ]
  }
}

# FAIL: Statement with kms:ReEncryptFrom action
resource "aws_iam_policy_document" "fail_kms_reencrypt_from" {
  expect_failure = true
  attrs = {
    statement = [
      {
        sid       = "AllowKmsReEncryptFrom"
        effect    = "Allow"
        actions   = ["kms:ReEncryptFrom"]
        resources = ["*"]
      }
    ]
  }
}

# FAIL: Statement with both kms:Decrypt and kms:ReEncryptFrom
resource "aws_iam_policy_document" "fail_both_blocked_actions" {
  expect_failure = true
  attrs = {
    statement = [
      {
        sid       = "AllowBothBlockedKms"
        effect    = "Allow"
        actions   = ["kms:Decrypt", "kms:ReEncryptFrom"]
        resources = ["*"]
      }
    ]
  }
}

# FAIL: Multiple statements — one has kms:Decrypt, another is compliant
resource "aws_iam_policy_document" "fail_mixed_statements_decrypt" {
  expect_failure = true
  attrs = {
    statement = [
      {
        sid       = "CompliantStatement"
        effect    = "Allow"
        actions   = ["kms:Encrypt", "kms:GenerateDataKey"]
        resources = ["arn:aws:kms:us-east-1:123456789012:key/12345"]
      },
      {
        sid       = "BlockedStatement"
        effect    = "Allow"
        actions   = ["kms:Decrypt"]
        resources = ["*"]
      }
    ]
  }
}

# FAIL: kms:Decrypt mixed with other non-blocked actions in same statement
resource "aws_iam_policy_document" "fail_decrypt_mixed_with_other_actions" {
  expect_failure = true
  attrs = {
    statement = [
      {
        sid       = "MixedKmsActions"
        effect    = "Allow"
        actions   = ["kms:Encrypt", "kms:Decrypt", "kms:GenerateDataKey"]
        resources = ["*"]
      }
    ]
  }
}

# FAIL: kms:ReEncryptFrom with Deny effect — blocked action regardless of effect
resource "aws_iam_policy_document" "fail_reencrypt_deny_effect" {
  expect_failure = true
  attrs = {
    statement = [
      {
        sid       = "DenyKmsReEncryptFrom"
        effect    = "Deny"
        actions   = ["kms:ReEncryptFrom"]
        resources = ["*"]
      }
    ]
  }
}
