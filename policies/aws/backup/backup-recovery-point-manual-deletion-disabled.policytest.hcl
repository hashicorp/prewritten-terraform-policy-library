# Copyright IBM Corp. 2026

policytest {
  targets = ["backup-recovery-point-manual-deletion-disabled.policy.hcl"]
}

# PASS case 1: Deny statement with Action as a list covering all 3 required actions.
resource "aws_backup_vault" "compliant_vault" {
  attrs = {
    name = "compliant-vault"
  }
}

resource "aws_backup_vault_policy" "compliant_vault_policy" {
  attrs = {
    backup_vault_name = "compliant-vault"
    policy            = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Deny\",\"Principal\":{\"AWS\":\"*\"},\"Action\":[\"backup:DeleteRecoveryPoint\",\"backup:UpdateRecoveryPointLifecycle\",\"backup:PutBackupVaultAccessPolicy\"],\"Resource\":\"*\"}]}"
  }
}

# PASS case 2: Action strings use mixed/upper case; matching must be case-insensitive.
resource "aws_backup_vault" "mixed_case_vault" {
  attrs = {
    name = "mixed-case-vault"
  }
}

resource "aws_backup_vault_policy" "mixed_case_vault_policy" {
  attrs = {
    backup_vault_name = "mixed-case-vault"
    policy            = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Deny\",\"Principal\":{\"AWS\":\"*\"},\"Action\":[\"Backup:DELETERECOVERYPOINT\",\"Backup:UPDATERECOVERYPOINTLIFECYCLE\",\"Backup:PUTBACKUPVAULTACCESSPOLICY\"],\"Resource\":\"*\"}]}"
  }
}

# PASS case 3: Principal.AWS is a single ARN string (not a list), all 3 actions covered.
resource "aws_backup_vault" "single_principal_string_vault" {
  attrs = {
    name = "single-principal-string-vault"
  }
}

resource "aws_backup_vault_policy" "single_principal_string_vault_policy" {
  attrs = {
    backup_vault_name = "single-principal-string-vault"
    policy            = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Deny\",\"Principal\":{\"AWS\":\"arn:aws:iam::123456789012:role/some-role\"},\"Action\":[\"backup:DeleteRecoveryPoint\",\"backup:UpdateRecoveryPointLifecycle\",\"backup:PutBackupVaultAccessPolicy\"],\"Resource\":\"*\"}]}"
  }
}

# FAIL case 1: No aws_backup_vault_policy resource exists for this vault at all.
resource "aws_backup_vault" "no_policy_vault" {
  expect_failure = true
  attrs = {
    name = "no-policy-vault"
  }
}

# FAIL case 2: Policy exists, but it only has an Allow statement (no Deny statement).
resource "aws_backup_vault" "allow_only_vault" {
  expect_failure = true
  attrs = {
    name = "allow-only-vault"
  }
}

resource "aws_backup_vault_policy" "allow_only_vault_policy" {
  attrs = {
    backup_vault_name = "allow-only-vault"
    policy            = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"*\"},\"Action\":[\"backup:DeleteRecoveryPoint\",\"backup:UpdateRecoveryPointLifecycle\",\"backup:PutBackupVaultAccessPolicy\"],\"Resource\":\"*\"}]}"
  }
}

# FAIL case 3: Deny statement is missing one of the three required actions.
resource "aws_backup_vault" "missing_action_vault" {
  expect_failure = true
  attrs = {
    name = "missing-action-vault"
  }
}

resource "aws_backup_vault_policy" "missing_action_vault_policy" {
  attrs = {
    backup_vault_name = "missing-action-vault"
    policy            = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Deny\",\"Principal\":{\"AWS\":\"*\"},\"Action\":[\"backup:DeleteRecoveryPoint\",\"backup:UpdateRecoveryPointLifecycle\"],\"Resource\":\"*\"}]}"
  }
}

# FAIL case 4: Vault policy document is an empty string.
resource "aws_backup_vault" "empty_policy_vault" {
  expect_failure = true
  attrs = {
    name = "empty-policy-vault"
  }
}

resource "aws_backup_vault_policy" "empty_policy_vault_policy" {
  attrs = {
    backup_vault_name = "empty-policy-vault"
    policy            = ""
  }
}

# ---- Cases merged from backup-recovery-point-manual-deletion-disabled-2.policytest.hcl ----


resource "aws_backup_vault_policy" "excluded_principal_vault_policy_f2" {
  attrs = {
    backup_vault_name = "excluded-principal-vault"
    policy            = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Deny\",\"Principal\":{\"AWS\":\"arn:aws:iam::123456789012:role/excluded-role\"},\"Action\":[\"backup:DeleteRecoveryPoint\",\"backup:UpdateRecoveryPointLifecycle\",\"backup:PutBackupVaultAccessPolicy\"],\"Resource\":\"*\"}]}"
  }
}

# PASS case: the Deny statement's Principal.AWS does NOT match the excluded ARN, so it
# is still evaluated normally and covers all required actions.
resource "aws_backup_vault" "non_excluded_principal_vault_f2" {
  attrs = {
    name = "non-excluded-principal-vault"
  }
}

resource "aws_backup_vault_policy" "non_excluded_principal_vault_policy_f2" {
  attrs = {
    backup_vault_name = "non-excluded-principal-vault"
    policy            = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Deny\",\"Principal\":{\"AWS\":\"arn:aws:iam::123456789012:role/some-other-role\"},\"Action\":[\"backup:DeleteRecoveryPoint\",\"backup:UpdateRecoveryPointLifecycle\",\"backup:PutBackupVaultAccessPolicy\"],\"Resource\":\"*\"}]}"
  }
}

# PASS: a single wildcard "backup:*" Deny covers all three actions.
resource "aws_backup_vault_policy" "wildcard_action_vault_policy" {
  attrs = {
    backup_vault_name = "wildcard-action-vault"
    policy            = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Deny\",\"Principal\":{\"AWS\":\"*\"},\"Action\":\"backup:*\",\"Resource\":\"*\"}]}"
  }
}

resource "aws_backup_vault" "wildcard_action_vault" {
  attrs = {
    name = "wildcard-action-vault"
  }
}

# FAIL: the Deny only applies under a Condition, so it does not always block deletion.
resource "aws_backup_vault_policy" "conditional_deny_vault_policy" {
  attrs = {
    backup_vault_name = "conditional-deny-vault"
    policy            = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Deny\",\"Principal\":{\"AWS\":\"*\"},\"Action\":[\"backup:DeleteRecoveryPoint\",\"backup:UpdateRecoveryPointLifecycle\",\"backup:PutBackupVaultAccessPolicy\"],\"Resource\":\"*\",\"Condition\":{\"StringEquals\":{\"aws:PrincipalTag/team\":\"dev\"}}}]}"
  }
}

resource "aws_backup_vault" "conditional_deny_vault" {
  expect_failure = true
  attrs = {
    name = "conditional-deny-vault"
  }
}
