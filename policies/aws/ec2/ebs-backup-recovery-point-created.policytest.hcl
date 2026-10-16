# Copyright IBM Corp. 2026

policytest {
  targets = ["ebs-backup-recovery-point-created.policy.hcl"]
}

# PASS scenarios using default inputs (max_hours_since_backup=24,
# resource_id="", resource_tags="", recovery_point_age_value=1,
# recovery_point_age_unit="days" -> required window = 24 hours).
# Every selection below is compliant, so overlapping universal matchers
# (wildcard "*" / generic ec2 volume patterns) only reinforce the PASS
# outcome for other volumes in this file and never cause a false result.

# Scenario 1: wildcard "*" selection + daily cron plan (24h) -> PASS
resource "aws_backup_plan" "compliant_daily" {
  attrs = {
    id   = "plan-daily-1"
    name = "daily-plan"
    rule = [
      {
        rule_name         = "daily-rule"
        target_vault_name = "default-vault"
        schedule          = "cron(0 12 * * ? *)"
      }
    ]
  }
}

resource "aws_backup_selection" "wildcard_match" {
  attrs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    name         = "wildcard-selection"
    plan_id      = "plan-daily-1"
    resources    = ["*"]
  }
}

resource "aws_ebs_volume" "wildcard_pass" {
  attrs = {
    id                = "vol-aaa1"
    arn               = "arn:aws:ec2:us-east-1:123456789012:volume/vol-aaa1"
    availability_zone = "us-east-1a"
  }
}

# Scenario 2: exact ARN match + rate(5 hours) plan -> PASS
resource "aws_backup_plan" "compliant_rate5h" {
  attrs = {
    id   = "plan-rate5h"
    name = "rate5h-plan"
    rule = [
      {
        rule_name         = "rate5h-rule"
        target_vault_name = "default-vault"
        schedule          = "rate(5 hours)"
      }
    ]
  }
}

resource "aws_backup_selection" "exact_arn_match" {
  attrs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    name         = "exact-arn-selection"
    plan_id      = "plan-rate5h"
    resources    = ["arn:aws:ec2:us-east-1:123456789012:volume/vol-aaa2"]
  }
}

resource "aws_ebs_volume" "exact_arn_pass" {
  attrs = {
    id                = "vol-aaa2"
    arn               = "arn:aws:ec2:us-east-1:123456789012:volume/vol-aaa2"
    availability_zone = "us-east-1a"
  }
}

# Scenario 3: suffix match (":volume/<id>") + rate(1 day) plan -> PASS
resource "aws_backup_plan" "compliant_rate1day" {
  attrs = {
    id   = "plan-rate1day"
    name = "rate1day-plan"
    rule = [
      {
        rule_name         = "rate1day-rule"
        target_vault_name = "default-vault"
        schedule          = "rate(1 day)"
      }
    ]
  }
}

resource "aws_backup_selection" "suffix_match" {
  attrs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    name         = "suffix-selection"
    plan_id      = "plan-rate1day"
    # Different account/region than the volume's own arn, but shares the
    # ":volume/<id>" suffix, forcing the suffix-match route (not exact ARN).
    resources = ["arn:aws-cn:ec2:cn-north-1:999999999999:volume/vol-aaa3"]
  }
}

resource "aws_ebs_volume" "suffix_pass" {
  attrs = {
    id                = "vol-aaa3"
    arn               = "arn:aws:ec2:us-east-1:123456789012:volume/vol-aaa3"
    availability_zone = "us-east-1a"
  }
}

# Scenario 4: generic wildcard pattern "arn:aws:ec2:*:*:volume/*" + cron(0 */6 * * ? *) -> PASS
resource "aws_backup_plan" "compliant_cron6h" {
  attrs = {
    id   = "plan-cron6h"
    name = "cron6h-plan"
    rule = [
      {
        rule_name         = "cron6h-rule"
        target_vault_name = "default-vault"
        schedule          = "cron(0 */6 * * ? *)"
      }
    ]
  }
}

resource "aws_backup_selection" "generic_wildcard_slash_star" {
  attrs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    name         = "generic-wildcard-selection"
    plan_id      = "plan-cron6h"
    resources    = ["arn:aws:ec2:*:*:volume/*"]
  }
}

resource "aws_ebs_volume" "generic_wildcard_pass" {
  attrs = {
    id                = "vol-aaa4"
    arn               = "arn:aws:ec2:us-east-1:123456789012:volume/vol-aaa4"
    availability_zone = "us-east-1a"
  }
}

# Scenario 5: generic wildcard pattern "arn:aws:ec2:*:*:volume/vol-*" + cron(*/15 * * * ? *) -> PASS
resource "aws_backup_plan" "compliant_cron15m" {
  attrs = {
    id   = "plan-cron15m"
    name = "cron15m-plan"
    rule = [
      {
        rule_name         = "cron15m-rule"
        target_vault_name = "default-vault"
        schedule          = "cron(*/15 * * * ? *)"
      }
    ]
  }
}

resource "aws_backup_selection" "generic_wildcard_vol_star" {
  attrs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    name         = "generic-wildcard-vol-selection"
    plan_id      = "plan-cron15m"
    resources    = ["arn:aws:ec2:*:*:volume/vol-*"]
  }
}

resource "aws_ebs_volume" "generic_wildcard_vol_pass" {
  attrs = {
    id                = "vol-aaa5"
    arn               = "arn:aws:ec2:us-east-1:123456789012:volume/vol-aaa5"
    availability_zone = "us-east-1a"
  }
}

# Scenario 6: tag-based selection match (STRINGEQUALS) + rate(12 hours) -> PASS
resource "aws_backup_plan" "compliant_rate12h" {
  attrs = {
    id   = "plan-rate12h"
    name = "rate12h-plan"
    rule = [
      {
        rule_name         = "rate12h-rule"
        target_vault_name = "default-vault"
        schedule          = "rate(12 hours)"
      }
    ]
  }
}

resource "aws_backup_selection" "tag_match" {
  attrs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    name         = "tag-selection"
    plan_id      = "plan-rate12h"
    selection_tag = [
      {
        key   = "Backup"
        type  = "STRINGEQUALS"
        value = "true"
      }
    ]
  }
}

resource "aws_ebs_volume" "tag_pass" {
  attrs = {
    id                = "vol-aaa6"
    availability_zone = "us-east-1a"
    tags = {
      Backup = "true"
    }
  }
}

# ---- Cases merged from ebs-backup-recovery-point-created-2.policytest.hcl ----


# Scenario 8: wildcard "*" selection references the volume, but the linked
# plan's only rule is rate(2 days) (48h), exceeding the default 24h window -> FAIL
resource "aws_backup_plan" "noncompliant_rate2days_f2" {
  attrs = {
    id   = "plan-rate2days"
    name = "rate2days-plan"
    rule = [
      {
        rule_name         = "rate2days-rule"
        target_vault_name = "default-vault"
        schedule          = "rate(2 days)"
      }
    ]
  }
}

resource "aws_backup_selection" "wildcard_slow_plan_f2" {
  attrs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    name         = "wildcard-slow-selection"
    plan_id      = "plan-rate2days"
    resources    = ["*"]
  }
}


# Scenario 9: wildcard "*" selection references the volume, but plan_id does
# not match any backup plan's id defined in the plan -> FAIL
resource "aws_backup_selection" "wildcard_bad_plan_id_f2" {
  attrs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    name         = "wildcard-bad-plan-id-selection"
    plan_id      = "plan-does-not-exist"
    resources    = ["*"]
  }
}


# Scenario 10: selection_tag type is STRINGLIKE (not STRINGEQUALS); even
# though a compliant plan is linked, the tag route never matches -> FAIL
resource "aws_backup_plan" "compliant_but_unreferenced_f2" {
  attrs = {
    id   = "plan-bbb10"
    name = "bbb10-plan"
    rule = [
      {
        rule_name         = "bbb10-rule"
        target_vault_name = "default-vault"
        schedule          = "rate(1 hours)"
      }
    ]
  }
}

resource "aws_backup_selection" "stringlike_tag_f2" {
  attrs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    name         = "stringlike-selection"
    plan_id      = "plan-bbb10"
    selection_tag = [
      {
        key   = "Backup"
        type  = "STRINGLIKE"
        value = "true"
      }
    ]
  }
}


# ---- Cases merged from ebs-backup-recovery-point-created-4.policytest.hcl ----

# Scenario 12: resource_id input set to a specific volume's id; a DIFFERENT
# volume (non-matching id, no backup coverage) is skipped (filtered out) ->
# PASS for that resource since it was never in scope for evaluation
resource "aws_ebs_volume" "non_matching_id_skipped_pass_f4" {
  attrs = {
    id                = "vol-ddd-other"
    arn               = "arn:aws:ec2:us-east-1:123456789012:volume/vol-ddd-other"
    availability_zone = "us-east-1a"
  }
}


# ---- Cases merged from ebs-backup-recovery-point-created-5.policytest.hcl ----

# Scenario 14: resource_tags filter is set, and this volume's tags do NOT
# include Environment=prod -> the volume is skipped (filtered out) -> PASS
# since it is out of scope
resource "aws_ebs_volume" "tags_mismatch_skipped_pass_f5" {
  attrs = {
    id                = "vol-eee14"
    availability_zone = "us-east-1a"
    tags = {
      Environment = "dev"
    }
  }
}


# ---- Cases merged from ebs-backup-recovery-point-created-6.policytest.hcl ----

# Scenario 16: required window = 2 hours, and the volume's backup plan rule
# has schedule = "rate(5 hours)" (5h), exceeding the 2-hour window -> FAIL
resource "aws_backup_plan" "rate5h_plan_f6" {
  attrs = {
    id   = "plan-fff16"
    name = "fff16-plan"
    rule = [
      {
        rule_name         = "fff16-rule"
        target_vault_name = "default-vault"
        schedule          = "rate(5 hours)"
      }
    ]
  }
}

resource "aws_backup_selection" "fff16_selection_f6" {
  attrs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    name         = "fff16-selection"
    plan_id      = "plan-fff16"
    resources    = ["*"]
  }
}


# ---- Cases merged from ebs-backup-recovery-point-created-7.policytest.hcl ----

# Scenario 17: required window = 72 hours, and the volume's backup plan rule
# has schedule = "rate(2 days)" (48h), within the 72-hour window -> PASS
resource "aws_backup_plan" "rate2days_plan_f7" {
  attrs = {
    id   = "plan-ggg17"
    name = "ggg17-plan"
    rule = [
      {
        rule_name         = "ggg17-rule"
        target_vault_name = "default-vault"
        schedule          = "rate(2 days)"
      }
    ]
  }
}

resource "aws_backup_selection" "ggg17_selection_f7" {
  attrs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    name         = "ggg17-selection"
    plan_id      = "plan-ggg17"
    resources    = ["*"]
  }
}

resource "aws_ebs_volume" "custom_window_days_pass_f7" {
  attrs = {
    id                = "vol-ggg17"
    arn               = "arn:aws:ec2:us-east-1:123456789012:volume/vol-ggg17"
    availability_zone = "us-east-1a"
  }
}

# ---- Cases merged from ebs-backup-recovery-point-created-8.policytest.hcl ----

# Scenario 18: max_hours_since_backup overridden to 12, and the volume's
# backup plan rule has schedule = "rate(1 day)" (24h), exceeding the 12-hour
# window -> FAIL
resource "aws_backup_plan" "rate1day_plan_f8" {
  attrs = {
    id   = "plan-hhh18"
    name = "hhh18-plan"
    rule = [
      {
        rule_name         = "hhh18-rule"
        target_vault_name = "default-vault"
        schedule          = "rate(1 day)"
      }
    ]
  }
}

resource "aws_backup_selection" "hhh18_selection_f8" {
  attrs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    name         = "hhh18-selection"
    plan_id      = "plan-hhh18"
    resources    = ["*"]
  }
}


# ---- Cases merged from ebs-backup-recovery-point-created-cron.policytest.hcl ----

resource "aws_backup_plan" "plan_weekly_f9" {
  skip = true
  attrs = {
    id   = "plan-cron-weekly"
    arn  = "arn:aws:backup:us-east-1:111111111111:backup-plan:plan-cron-weekly"
    name = "plan-cron-weekly"
    rule = [{ rule_name = "r", target_vault_name = "v", schedule = "cron(0 5 ? * MON *)" }]
  }
}

resource "aws_backup_selection" "sel_weekly_f9" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup"
    name          = "sel-cron-weekly"
    plan_id       = "plan-cron-weekly"
    resources     = ["arn:aws:ec2:us-east-1:111111111111:volume/cron-weekly"]
    selection_tag = []
  }
}


resource "aws_backup_plan" "plan_monthly_f9" {
  skip = true
  attrs = {
    id   = "plan-cron-monthly"
    arn  = "arn:aws:backup:us-east-1:111111111111:backup-plan:plan-cron-monthly"
    name = "plan-cron-monthly"
    rule = [{ rule_name = "r", target_vault_name = "v", schedule = "cron(0 5 1 * ? *)" }]
  }
}

resource "aws_backup_selection" "sel_monthly_f9" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup"
    name          = "sel-cron-monthly"
    plan_id       = "plan-cron-monthly"
    resources     = ["arn:aws:ec2:us-east-1:111111111111:volume/cron-monthly"]
    selection_tag = []
  }
}


resource "aws_backup_plan" "plan_daily_q_f9" {
  skip = true
  attrs = {
    id   = "plan-cron-daily-q"
    arn  = "arn:aws:backup:us-east-1:111111111111:backup-plan:plan-cron-daily-q"
    name = "plan-cron-daily-q"
    rule = [{ rule_name = "r", target_vault_name = "v", schedule = "cron(0 5 ? * * *)" }]
  }
}

resource "aws_backup_selection" "sel_daily_q_f9" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup"
    name          = "sel-cron-daily-q"
    plan_id       = "plan-cron-daily-q"
    resources     = ["arn:aws:ec2:us-east-1:111111111111:volume/cron-daily-q"]
    selection_tag = []
  }
}

resource "aws_ebs_volume" "pass_cron_daily_q_f9" {
  attrs = {
    id                = "cron-daily-q"
    arn               = "arn:aws:ec2:us-east-1:111111111111:volume/cron-daily-q"
    availability_zone = "us-east-1a"
    tags              = {}
  }
}

resource "aws_backup_plan" "plan_every6h_f9" {
  skip = true
  attrs = {
    id   = "plan-cron-every6h"
    arn  = "arn:aws:backup:us-east-1:111111111111:backup-plan:plan-cron-every6h"
    name = "plan-cron-every6h"
    rule = [{ rule_name = "r", target_vault_name = "v", schedule = "cron(0 */6 * * ? *)" }]
  }
}

resource "aws_backup_selection" "sel_every6h_f9" {
  skip = true
  attrs = {
    iam_role_arn  = "arn:aws:iam::111111111111:role/backup"
    name          = "sel-cron-every6h"
    plan_id       = "plan-cron-every6h"
    resources     = ["arn:aws:ec2:us-east-1:111111111111:volume/cron-every6h"]
    selection_tag = []
  }
}

resource "aws_ebs_volume" "pass_cron_every6h_f9" {
  attrs = {
    id                = "cron-every6h"
    arn               = "arn:aws:ec2:us-east-1:111111111111:volume/cron-every6h"
    availability_zone = "us-east-1a"
    tags              = {}
  }
}
