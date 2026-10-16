# Copyright IBM Corp. 2026

policytest {
  targets = ["efs-recovery-point-compliance.policy.hcl"]
}

# Main test file. Uses the policy's default input values:
#   resource_id = "", resource_tags = "", recovery_point_max_age_hours = 24,
#   recovery_point_age_value = 1, recovery_point_age_unit = "days"
# (=> required_hours = 24, since recovery_point_age_value/unit are both at
# their Sentinel defaults).
#
# NOTE: Scenarios that rely on a wildcard `resources = ["*"]` backup
# selection are intentionally NOT included here. core::getresources() sees
# every mock resource of a type declared anywhere in the file, so a
# wildcard selection here would silently "cover" every other EFS resource
# below. Those scenarios live in isolated files (-2 and -3).
#
# NOTE: Scenarios that require non-default `inputs {}` values (resourceId
# filter, resourceTags filter, custom recoveryPointAgeValue/Unit) are also
# NOT included here, since a file can only declare one `inputs {}` block.
# Those scenarios live in isolated files (-4 through -7).

# 1) No backup selection references this EFS file system at all -> violation.
#    Also exercises the "missing attribute" case: `tags` is omitted entirely.
resource "aws_efs_file_system" "no_selection_at_all" {
  expect_failure = true
  attrs = {
    id             = "fs-00000001"
    arn            = "arn:aws:elasticfilesystem:us-east-1:123456789012:file-system/fs-00000001"
    creation_token = "efs-no-selection"
    encrypted      = true
  }
}

# 2) Covered by resources = [arn], plan has a cron(0 */6 * * ? *) rule
#    (frequency 6h) -> 6h <= 24h required -> pass.
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

# 3) Covered by resources = [arn], plan has a rate(2 days) rule (48h)
#    -> 48h > 24h required -> violation.
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

# 4) Covered via selection_tag (STRINGEQUALS Backup=true), EFS has the
#    matching tag, plan rate(1 days) = 24h <= 24h required -> pass.
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

# 5) Covered via selection_tag (STRINGEQUALS Backup=true-mismatch), but the
#    EFS resource's own tag value does not match -> tag_match fails ->
#    selection does not cover the EFS -> violation.
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

# 6) Covered via a selection_tag whose type is STRINGLIKE instead of
#    STRINGEQUALS -> only STRINGEQUALS is supported for selection_tag
#    matching (matches Sentinel's selection_matches_efs_tags) -> violation.
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

# 7) Covered by resources = [arn], but the plan has zero rule entries ->
#    a plan with no rules can never be compliant -> violation.
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

# 8) Covered by resources = [arn], but the selection's plan_id does not
#    match the id of any aws_backup_plan resource in the plan -> violation.
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

# 9) Covered via a condition block (string_equals Backup=true-cond-eq), EFS
#    has the matching tag, compliant plan -> pass.
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

# 10) Covered via a condition block (string_not_equals Environment=test),
#     EFS tags Environment=prod-cond-neq (not equal to "test") -> pass.
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

# 11) Covered via a condition block (string_equals Backup=true-cond-no-tags),
#     but the EFS resource has NO tags at all -> condition_match requires
#     non-empty EFS tags -> violation.
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
