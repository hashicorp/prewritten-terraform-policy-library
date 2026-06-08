# Copyright IBM Corp. 2026

policytest {
    targets = [
        "backup-recovery-point-encrypted.policy.hcl"
    ]
}

# Test 1: PASS - Recovery point is encrypted
resource "aws_backup_framework" "pass_encrypted" {
    attrs = {
        name = "test-framework-pass-encrypted"
        control = {
            name = "BACKUP_RECOVERY_POINT_ENCRYPTED"
        }
    }
}

# Test 2: FAIL - Recovery point is not encrypted
resource "aws_backup_framework" "fail_encrypted" {
    expect_failure = true
    attrs = {
        name = "test-framework-fail-encrypted"
        control = {
            name = "BACKUP_RECOVERY_POINT_MANUAL_DELETION_DISABLED"
        }
    }
}

# Test 3: FAIL - Empty control block
resource "aws_backup_framework" "fail_empty" {
    expect_failure = true
    attrs = {
        name = "test-framework-fail-empty"
    }
}
