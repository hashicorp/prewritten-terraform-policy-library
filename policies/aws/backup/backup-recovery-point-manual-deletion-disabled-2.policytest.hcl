# Copyright IBM Corp. 2026

# Separate file: this file overrides inputs.excluded_principal_arns (see rule 4.2
# case 1 in testcase_gen.md — a file can contain only one `inputs {}` block, and this
# scenario requires a non-default value, so it cannot share the default-input file.
policytest {
  targets = ["backup-recovery-point-manual-deletion-disabled.policy.hcl"]
}

inputs {
  backup-recovery-point-manual-deletion-disabled-excluded_principal_arns = ["arn:aws:iam::123456789012:role/excluded-role"]
}

# FAIL case: the only qualifying Deny statement's Principal.AWS matches the excluded
# ARN exactly, so it is skipped, leaving no compliant Deny statement.
resource "aws_backup_vault" "excluded_principal_vault" {
  expect_failure = true
  attrs = {
    name = "excluded-principal-vault"
  }
}

resource "aws_backup_vault_policy" "excluded_principal_vault_policy" {
  attrs = {
    backup_vault_name = "excluded-principal-vault"
    policy            = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Deny\",\"Principal\":{\"AWS\":\"arn:aws:iam::123456789012:role/excluded-role\"},\"Action\":[\"backup:DeleteRecoveryPoint\",\"backup:UpdateRecoveryPointLifecycle\",\"backup:PutBackupVaultAccessPolicy\"],\"Resource\":\"*\"}]}"
  }
}

# PASS case: the Deny statement's Principal.AWS does NOT match the excluded ARN, so it
# is still evaluated normally and covers all required actions.
resource "aws_backup_vault" "non_excluded_principal_vault" {
  attrs = {
    name = "non-excluded-principal-vault"
  }
}

resource "aws_backup_vault_policy" "non_excluded_principal_vault_policy" {
  attrs = {
    backup_vault_name = "non-excluded-principal-vault"
    policy            = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Deny\",\"Principal\":{\"AWS\":\"arn:aws:iam::123456789012:role/some-other-role\"},\"Action\":[\"backup:DeleteRecoveryPoint\",\"backup:UpdateRecoveryPointLifecycle\",\"backup:PutBackupVaultAccessPolicy\"],\"Resource\":\"*\"}]}"
  }
}
