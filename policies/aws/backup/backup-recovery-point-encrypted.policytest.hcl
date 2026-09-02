# Copyright IBM Corp. 2026

policytest {
    targets = [
        "backup-recovery-point-encrypted.policy.hcl"
    ]
}

# Test 1: PASS - Backup vault with kms_key_arn configured
resource "aws_backup_vault" "pass_encrypted" {
    attrs = {
        name        = "encrypted-vault"
        kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/a1b2c3d4-e5f6-7890-abcd-ef1234567890"
    }
}

# Test 2: FAIL - Backup vault with no kms_key_arn
resource "aws_backup_vault" "fail_no_kms_key" {
    expect_failure = true
    attrs = {
        name = "unencrypted-vault"
    }
}

# Test 3: FAIL - Backup vault with empty kms_key_arn
resource "aws_backup_vault" "fail_empty_kms_key" {
    expect_failure = true
    attrs = {
        name        = "empty-kms-key-vault"
        kms_key_arn = ""
    }
}

# Test 4: PASS - Backup vault with a different valid kms_key_arn
resource "aws_backup_vault" "pass_encrypted_second" {
    attrs = {
        name        = "encrypted-vault-2"
        kms_key_arn = "arn:aws:kms:us-west-2:123456789012:key/b2c3d4e5-f6a7-8901-bcde-f12345678901"
    }
}
