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
