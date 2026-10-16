# Copyright IBM Corp. 2026

# Separate file: default inputs (same as the first file), but isolated so
# that it contains NO globally-compliant universal matcher (wildcard "*" or
# the generic "arn:aws:ec2:*:*:volume/*" patterns). The first file's PASS
# scenarios rely on compliant universal matchers that would otherwise flip
# every FAIL case below to PASS if combined into the same file.
policytest {
  targets = ["ebs-backup-recovery-point-created.policy.hcl"]
}

# Scenario 7: volume is not referenced (by ARN, wildcard, suffix, or tag) by
# any backup selection -> FAIL
resource "aws_ebs_volume" "not_referenced_fail" {
  expect_failure = true
  attrs = {
    id                = "vol-bbb7"
    arn               = "arn:aws:ec2:us-east-1:123456789012:volume/vol-bbb7"
    availability_zone = "us-east-1a"
    tags              = {}
  }
}

# Scenario 8: wildcard "*" selection references the volume, but the linked
# plan's only rule is rate(2 days) (48h), exceeding the default 24h window -> FAIL
resource "aws_backup_plan" "noncompliant_rate2days" {
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

resource "aws_backup_selection" "wildcard_slow_plan" {
  attrs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    name         = "wildcard-slow-selection"
    plan_id      = "plan-rate2days"
    resources    = ["*"]
  }
}

resource "aws_ebs_volume" "wildcard_slow_plan_fail" {
  expect_failure = true
  attrs = {
    id                = "vol-bbb8"
    arn               = "arn:aws:ec2:us-east-1:123456789012:volume/vol-bbb8"
    availability_zone = "us-east-1a"
  }
}

# Scenario 9: wildcard "*" selection references the volume, but plan_id does
# not match any backup plan's id defined in the plan -> FAIL
resource "aws_backup_selection" "wildcard_bad_plan_id" {
  attrs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/backup-role"
    name         = "wildcard-bad-plan-id-selection"
    plan_id      = "plan-does-not-exist"
    resources    = ["*"]
  }
}

resource "aws_ebs_volume" "wildcard_bad_plan_id_fail" {
  expect_failure = true
  attrs = {
    id                = "vol-bbb9"
    arn               = "arn:aws:ec2:us-east-1:123456789012:volume/vol-bbb9"
    availability_zone = "us-east-1a"
  }
}

# Scenario 10: selection_tag type is STRINGLIKE (not STRINGEQUALS); even
# though a compliant plan is linked, the tag route never matches -> FAIL
resource "aws_backup_plan" "compliant_but_unreferenced" {
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

resource "aws_backup_selection" "stringlike_tag" {
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

resource "aws_ebs_volume" "stringlike_tag_fail" {
  expect_failure = true
  attrs = {
    id                = "vol-bbb10"
    availability_zone = "us-east-1a"
    tags = {
      Backup = "true"
    }
  }
}
