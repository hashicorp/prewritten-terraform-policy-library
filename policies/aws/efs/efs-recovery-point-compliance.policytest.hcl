# Copyright IBM Corp. 2026

policytest {
  targets = ["efs-recovery-point-compliance.policy.hcl"]
}

# FAIL: no selection at all
resource "aws_efs_file_system" "no_selection_at_all" {
  expect_failure = true
  attrs = {
    id             = "fs-00000001"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000001"
    creation_token = "efs-no-selection"
    encrypted      = true
  }
}

# PASS: Covered by resources = [arn], plan has a cron(0 */6 * * ? *) rule (frequency 6h)
resource "aws_efs_file_system" "specific_arn_compliant_cron" {
  attrs = {
    id             = "fs-00000002"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000002"
    creation_token = "efs-specific-arn-compliant"
    encrypted      = true
    tags           = {}
  }
}

resource "aws_backup_plan" "plan_cron_6h" {
  skip = true
  attrs = {
    id   = "plan-cron-6h"
    name = "plan-cron-6h"
    rule = [{
      rule_name         = "rule-cron-6h"
      target_vault_name = "vault-1"
      schedule          = "cron(0 */6 * * ? *)"
    }]
  }
}

resource "aws_backup_selection" "selection_arn_cron_6h" {
  skip = true
  attrs = {
    id           = "selection-arn-cron-6h"
    name         = "selection-arn-cron-6h"
    plan_id      = "plan-cron-6h"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources    = ["arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000002"]
  }
}

# FAIL: Covered by resources = [arn], plan has a rate(2 days) rule (48h)
resource "aws_efs_file_system" "specific_arn_noncompliant_rate" {
  expect_failure = true
  attrs = {
    id             = "fs-00000003"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000003"
    creation_token = "efs-specific-arn-noncompliant"
    encrypted      = true
    tags           = {}
  }
}

resource "aws_backup_plan" "plan_rate_48h" {
  skip = true
  attrs = {
    id   = "plan-rate-48h"
    name = "plan-rate-48h"
    rule = [{
      rule_name         = "rule-rate-48h"
      target_vault_name = "vault-1"
      schedule          = "rate(2 days)"
    }]
  }
}

resource "aws_backup_selection" "selection_arn_rate_48h" {
  skip = true
  attrs = {
    id           = "selection-arn-rate-48h"
    name         = "selection-arn-rate-48h"
    plan_id      = "plan-rate-48h"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources    = ["arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000003"]
  }
}

# PASS: tag match pass
resource "aws_efs_file_system" "tag_match_pass" {
  attrs = {
    id             = "fs-00000004"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000004"
    creation_token = "efs-tag-match-pass"
    encrypted      = true
    tags = {
      Backup = "true-tag-match-pass"
    }
  }
}

resource "aws_backup_plan" "plan_rate_24h" {
  skip = true
  attrs = {
    id   = "plan-rate-24h"
    name = "plan-rate-24h"
    rule = [{
      rule_name         = "rule-rate-24h"
      target_vault_name = "vault-1"
      schedule          = "rate(1 days)"
    }]
  }
}

resource "aws_backup_selection" "selection_tag_match_pass" {
  skip = true
  attrs = {
    id           = "selection-tag-match-pass"
    name         = "selection-tag-match-pass"
    plan_id      = "plan-rate-24h"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    selection_tag = [{
      key   = "Backup"
      type  = "STRINGEQUALS"
      value = "true-tag-match-pass"
    }]
  }
}

# FAIL: tag mismatch fail
resource "aws_efs_file_system" "tag_mismatch_fail" {
  expect_failure = true
  attrs = {
    id             = "fs-00000005"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000005"
    creation_token = "efs-tag-mismatch"
    encrypted      = true
    # Environment is deliberately set to match scenario 10's string_not_equals
    # value ("test-cond-neq"), so that unrelated selection does NOT
    # accidentally cover this resource via core::getresources() (which sees
    # every mock resource in the file, regardless of scenario).
    tags = {
      Backup      = "false-tag-mismatch"
      Environment = "test-cond-neq"
    }
  }
}

resource "aws_backup_selection" "selection_tag_mismatch_fail" {
  skip = true
  attrs = {
    id           = "selection-tag-mismatch-fail"
    name         = "selection-tag-mismatch-fail"
    plan_id      = "plan-rate-24h"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    selection_tag = [{
      key   = "Backup"
      type  = "STRINGEQUALS"
      value = "true-tag-mismatch"
    }]
  }
}

# FAIL: Covered via a selection_tag whose type is STRINGLIKE instead of STRINGEQUALS
resource "aws_efs_file_system" "tag_wrong_type_fail" {
  expect_failure = true
  attrs = {
    id             = "fs-00000006"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000006"
    creation_token = "efs-tag-wrong-type"
    encrypted      = true
    # Environment is deliberately set to match scenario 10's string_not_equals
    # value ("test-cond-neq"), so that unrelated selection does NOT
    # accidentally cover this resource via core::getresources() (which sees
    # every mock resource in the file, regardless of scenario).
    tags = {
      Backup      = "true-wrong-type"
      Environment = "test-cond-neq"
    }
  }
}

resource "aws_backup_selection" "selection_tag_wrong_type_fail" {
  skip = true
  attrs = {
    id           = "selection-tag-wrong-type-fail"
    name         = "selection-tag-wrong-type-fail"
    plan_id      = "plan-rate-24h"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    selection_tag = [{
      key   = "Backup"
      type  = "STRINGLIKE"
      value = "true-wrong-type"
    }]
  }
}

# FAIL: Covered by resources = [arn], but the plan has zero rule entries
resource "aws_efs_file_system" "plan_zero_rules_fail" {
  expect_failure = true
  attrs = {
    id             = "fs-00000007"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000007"
    creation_token = "efs-plan-zero-rules"
    encrypted      = true
    tags           = {}
  }
}

resource "aws_backup_plan" "plan_zero_rules" {
  skip = true
  attrs = {
    id   = "plan-zero-rules"
    name = "plan-zero-rules"
    rule = []
  }
}

resource "aws_backup_selection" "selection_plan_zero_rules_fail" {
  skip = true
  attrs = {
    id           = "selection-plan-zero-rules-fail"
    name         = "selection-plan-zero-rules-fail"
    plan_id      = "plan-zero-rules"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources    = ["arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000007"]
  }
}

# FAIL: plan id mismatch fail
resource "aws_efs_file_system" "plan_id_mismatch_fail" {
  expect_failure = true
  attrs = {
    id             = "fs-00000008"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000008"
    creation_token = "efs-plan-id-mismatch"
    encrypted      = true
    tags           = {}
  }
}

resource "aws_backup_selection" "selection_plan_id_mismatch_fail" {
  skip = true
  attrs = {
    id           = "selection-plan-id-mismatch-fail"
    name         = "selection-plan-id-mismatch-fail"
    plan_id      = "plan-does-not-exist"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources    = ["arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000008"]
  }
}

# PASS: Covered via a condition block (string_equals Backup=true-cond-eq), EFS has the matching tag, compliant plan
resource "aws_efs_file_system" "condition_string_equals_pass" {
  attrs = {
    id             = "fs-00000009"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000009"
    creation_token = "efs-condition-string-equals"
    encrypted      = true
    tags = {
      Backup = "true-cond-eq"
    }
  }
}

resource "aws_backup_selection" "selection_condition_string_equals_pass" {
  skip = true
  attrs = {
    id           = "selection-condition-string-equals-pass"
    name         = "selection-condition-string-equals-pass"
    plan_id      = "plan-rate-24h"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    condition = [{
      string_equals = [{
        key   = "Backup"
        value = "true-cond-eq"
      }]
    }]
  }
}

# PASS: condition string not equals pass
resource "aws_efs_file_system" "condition_string_not_equals_pass" {
  attrs = {
    id             = "fs-00000010"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000010"
    creation_token = "efs-condition-string-not-equals"
    encrypted      = true
    tags = {
      Environment = "prod-cond-neq"
    }
  }
}

resource "aws_backup_selection" "selection_condition_string_not_equals_pass" {
  skip = true
  attrs = {
    id           = "selection-condition-string-not-equals-pass"
    name         = "selection-condition-string-not-equals-pass"
    plan_id      = "plan-rate-24h"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    condition = [{
      string_not_equals = [{
        key   = "Environment"
        value = "test-cond-neq"
      }]
    }]
  }
}

# FAIL: condition no tags fail
resource "aws_efs_file_system" "condition_no_tags_fail" {
  expect_failure = true
  attrs = {
    id             = "fs-00000011"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000011"
    creation_token = "efs-condition-no-tags"
    encrypted      = true
  }
}

resource "aws_backup_selection" "selection_condition_no_tags_fail" {
  skip = true
  attrs = {
    id           = "selection-condition-no-tags-fail"
    name         = "selection-condition-no-tags-fail"
    plan_id      = "plan-rate-24h"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    condition = [{
      string_equals = [{
        key   = "Backup"
        value = "true-cond-no-tags"
      }]
    }]
  }
}

# PASS: resource id match pass
resource "aws_efs_file_system" "resource_id_match_pass_f4" {
  attrs = {
    id             = "fs-00000014"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000014"
    creation_token = "efs-resource-id-match"
    encrypted      = true
    tags           = {}
  }
}

resource "aws_backup_plan" "plan_for_resource_id_match_f4" {
  skip = true
  attrs = {
    id   = "plan-for-resource-id-match"
    name = "plan-for-resource-id-match"
    rule = [{
      rule_name         = "rule-for-resource-id-match"
      target_vault_name = "vault-1"
      schedule          = "rate(1 hours)"
    }]
  }
}

resource "aws_backup_selection" "selection_for_resource_id_match_f4" {
  skip = true
  attrs = {
    id           = "selection-for-resource-id-match"
    name         = "selection-for-resource-id-match"
    plan_id      = "plan-for-resource-id-match"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources    = ["arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000014"]
  }
}

# PASS: resource tags match pass
resource "aws_efs_file_system" "resource_tags_match_pass_f5" {
  attrs = {
    id             = "fs-00000016"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000016"
    creation_token = "efs-resource-tags-match"
    encrypted      = true
    tags = {
      Env = "prod"
    }
  }
}

resource "aws_backup_plan" "plan_for_resource_tags_match_f5" {
  skip = true
  attrs = {
    id   = "plan-for-resource-tags-match"
    name = "plan-for-resource-tags-match"
    rule = [{
      rule_name         = "rule-for-resource-tags-match"
      target_vault_name = "vault-1"
      schedule          = "rate(1 hours)"
    }]
  }
}

resource "aws_backup_selection" "selection_for_resource_tags_match_f5" {
  skip = true
  attrs = {
    id           = "selection-for-resource-tags-match"
    name         = "selection-for-resource-tags-match"
    plan_id      = "plan-for-resource-tags-match"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources    = ["arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000016"]
  }
}

# PASS: Does NOT match resourceTags (tags.Env = "dev", not "prod")
resource "aws_efs_file_system" "resource_tags_no_match_skipped_f5" {
  attrs = {
    id             = "fs-00000017"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000017"
    creation_token = "efs-resource-tags-no-match"
    encrypted      = true
    tags = {
      Env = "dev"
    }
  }
}

# PASS: age value hours compliant pass
resource "aws_efs_file_system" "age_value_hours_compliant_pass_f6" {
  attrs = {
    id             = "fs-00000018"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000018"
    creation_token = "efs-age-value-hours-compliant"
    encrypted      = true
    tags           = {}
  }
}

resource "aws_backup_plan" "plan_rate_2h_f6" {
  skip = true
  attrs = {
    id   = "plan-rate-2h"
    name = "plan-rate-2h"
    rule = [{
      rule_name         = "rule-rate-2h"
      target_vault_name = "vault-1"
      schedule          = "rate(2 hours)"
    }]
  }
}

resource "aws_backup_selection" "selection_age_value_hours_compliant_f6" {
  skip = true
  attrs = {
    id           = "selection-age-value-hours-compliant"
    name         = "selection-age-value-hours-compliant"
    plan_id      = "plan-rate-2h"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources    = ["arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000018"]
  }
}

resource "aws_backup_plan" "plan_rate_3h_f6" {
  skip = true
  attrs = {
    id   = "plan-rate-3h"
    name = "plan-rate-3h"
    rule = [{
      rule_name         = "rule-rate-3h"
      target_vault_name = "vault-1"
      schedule          = "rate(3 hours)"
    }]
  }
}

resource "aws_backup_selection" "selection_age_value_hours_noncompliant_f6" {
  skip = true
  attrs = {
    id           = "selection-age-value-hours-noncompliant"
    name         = "selection-age-value-hours-noncompliant"
    plan_id      = "plan-rate-3h"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources    = ["arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000019"]
  }
}

resource "aws_backup_plan" "plan_rate_48h_f7" {
  skip = true
  attrs = {
    id   = "plan-rate-48h-v2"
    name = "plan-rate-48h-v2"
    rule = [{
      rule_name         = "rule-rate-48h-v2"
      target_vault_name = "vault-1"
      schedule          = "rate(2 days)"
    }]
  }
}

resource "aws_backup_selection" "selection_age_value_days_compliant_f7" {
  skip = true
  attrs = {
    id           = "selection-age-value-days-compliant"
    name         = "selection-age-value-days-compliant"
    plan_id      = "plan-rate-48h-v2"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources    = ["arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000020"]
  }
}

# FAIL: Covered by resources = [arn], plan has a rate(3 days) rule (frequency 72h)
resource "aws_efs_file_system" "age_value_days_noncompliant_fail_f7" {
  expect_failure = true
  attrs = {
    id             = "fs-00000021"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000021"
    creation_token = "efs-age-value-days-noncompliant"
    encrypted      = true
    tags           = {}
  }
}

resource "aws_backup_plan" "plan_rate_72h_f7" {
  skip = true
  attrs = {
    id   = "plan-rate-72h"
    name = "plan-rate-72h"
    rule = [{
      rule_name         = "rule-rate-72h"
      target_vault_name = "vault-1"
      schedule          = "rate(3 days)"
    }]
  }
}

resource "aws_backup_selection" "selection_age_value_days_noncompliant_f7" {
  skip = true
  attrs = {
    id           = "selection-age-value-days-noncompliant"
    name         = "selection-age-value-days-noncompliant"
    plan_id      = "plan-rate-72h"
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    resources    = ["arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000021"]
  }
}

resource "aws_backup_plan" "plan_weekly_f8" {
  skip = true
  attrs = {
    id   = "plan-cron-weekly"
    arn  = "arn:aws:backup:us-east-1:111111111111:backup-plan:plan-cron-weekly"
    name = "plan-cron-weekly"
    rule = [{ rule_name = "r", target_vault_name = "v", schedule = "cron(0 5 ? * MON *)" }]
  }
}

resource "aws_backup_selection" "sel_weekly_f8" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup"
    name          = "sel-cron-weekly"
    plan_id       = "plan-cron-weekly"
    resources     = ["arn:aws:elasticfilesystem:us-east-1:111111111111:file-system/cron-weekly"]
    selection_tag = []
  }
}

# FAIL: cron weekly
resource "aws_efs_file_system" "fail_cron_weekly_f8" {
  expect_failure = true
  attrs = {
    id             = "cron-weekly"
    arn            = "arn:aws:elasticfilesystem:us-east-1:111111111111:file-system/cron-weekly"
    creation_token = "cron-weekly"
    encrypted      = true
    tags           = {}
  }
}

resource "aws_backup_plan" "plan_monthly_f8" {
  skip = true
  attrs = {
    id   = "plan-cron-monthly"
    arn  = "arn:aws:backup:us-east-1:111111111111:backup-plan:plan-cron-monthly"
    name = "plan-cron-monthly"
    rule = [{ rule_name = "r", target_vault_name = "v", schedule = "cron(0 5 1 * ? *)" }]
  }
}

resource "aws_backup_selection" "sel_monthly_f8" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup"
    name          = "sel-cron-monthly"
    plan_id       = "plan-cron-monthly"
    resources     = ["arn:aws:elasticfilesystem:us-east-1:111111111111:file-system/cron-monthly"]
    selection_tag = []
  }
}

# FAIL: cron monthly
resource "aws_efs_file_system" "fail_cron_monthly_f8" {
  expect_failure = true
  attrs = {
    id             = "cron-monthly"
    arn            = "arn:aws:elasticfilesystem:us-east-1:111111111111:file-system/cron-monthly"
    creation_token = "cron-monthly"
    encrypted      = true
    tags           = {}
  }
}

resource "aws_backup_plan" "plan_daily_q_f8" {
  skip = true
  attrs = {
    id   = "plan-cron-daily-q"
    arn  = "arn:aws:backup:us-east-1:111111111111:backup-plan:plan-cron-daily-q"
    name = "plan-cron-daily-q"
    rule = [{ rule_name = "r", target_vault_name = "v", schedule = "cron(0 5 ? * * *)" }]
  }
}

resource "aws_backup_selection" "sel_daily_q_f8" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup"
    name          = "sel-cron-daily-q"
    plan_id       = "plan-cron-daily-q"
    resources     = ["arn:aws:elasticfilesystem:us-east-1:111111111111:file-system/cron-daily-q"]
    selection_tag = []
  }
}

# PASS: cron daily q
resource "aws_efs_file_system" "pass_cron_daily_q_f8" {
  attrs = {
    id             = "cron-daily-q"
    arn            = "arn:aws:elasticfilesystem:us-east-1:111111111111:file-system/cron-daily-q"
    creation_token = "cron-daily-q"
    encrypted      = true
    tags           = {}
  }
}

resource "aws_backup_plan" "plan_every6h_f8" {
  skip = true
  attrs = {
    id   = "plan-cron-every6h"
    arn  = "arn:aws:backup:us-east-1:111111111111:backup-plan:plan-cron-every6h"
    name = "plan-cron-every6h"
    rule = [{ rule_name = "r", target_vault_name = "v", schedule = "cron(0 */6 * * ? *)" }]
  }
}

resource "aws_backup_selection" "sel_every6h_f8" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup"
    name          = "sel-cron-every6h"
    plan_id       = "plan-cron-every6h"
    resources     = ["arn:aws:elasticfilesystem:us-east-1:111111111111:file-system/cron-every6h"]
    selection_tag = []
  }
}

# PASS: cron every6h
resource "aws_efs_file_system" "pass_cron_every6h_f8" {
  attrs = {
    id             = "cron-every6h"
    arn            = "arn:aws:elasticfilesystem:us-east-1:111111111111:file-system/cron-every6h"
    creation_token = "cron-every6h"
    encrypted      = true
    tags           = {}
  }
}
