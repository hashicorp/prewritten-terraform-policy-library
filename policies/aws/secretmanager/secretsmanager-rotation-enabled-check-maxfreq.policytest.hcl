# Copyright IBM Corp. 2026

policytest {
  targets = [
    "secretsmanager-rotation-enabled-check.policy.hcl"
  ]
}

inputs {
    maximumAllowedRotationFrequency = 90
  }

# Test: FAIL - Secret with excessive rotation frequency (120 days) when max is 90
resource "aws_secretsmanager_secret" "excessive_frequency_secret" {
  expect_failure = true
  attrs = {
    arn  = "arn:aws:secretsmanager:us-east-1:123456789012:secret:excessive"
    name = "excessive-frequency-secret"
    id   = "excessive-frequency-secret-id"
  }
}

resource "aws_secretsmanager_secret_rotation" "excessive_frequency_secret" {
  attrs = {
    secret_id = "excessive-frequency-secret"
    rotation_rules = [
      {
        automatically_after_days = 120
      }
    ]
  }
}

# Test: PASS - Secret within rotation frequency limit (60 < 90)
resource "aws_secretsmanager_secret" "within_frequency_secret" {
  attrs = {
    arn  = "arn:aws:secretsmanager:us-east-1:123456789012:secret:within"
    name = "within-frequency-secret"
    id   = "within-frequency-secret-id"
  }
}

resource "aws_secretsmanager_secret_rotation" "within_frequency_secret" {
  attrs = {
    secret_id = "within-frequency-secret"
    rotation_rules = [
      {
        automatically_after_days = 60
      }
    ]
  }
}

# Test: PASS - Secret at exact frequency limit (90 == 90, not exceeding)
resource "aws_secretsmanager_secret" "at_limit_secret" {
  attrs = {
    arn  = "arn:aws:secretsmanager:us-east-1:123456789012:secret:atlimit"
    name = "at-limit-secret"
    id   = "at-limit-secret-id"
  }
}

resource "aws_secretsmanager_secret_rotation" "at_limit_secret" {
  attrs = {
    secret_id = "at-limit-secret"
    rotation_rules = [
      {
        automatically_after_days = 90
      }
    ]
  }
}

# Test: PASS - At least one related rotation candidate meets the maximum frequency
resource "aws_secretsmanager_secret" "multiple_rotation_secret" {
  attrs = {
    arn  = "arn:aws:secretsmanager:us-east-1:123456789012:secret:multiple-rotation"
    name = "multiple-rotation-secret"
    id   = "multiple-rotation-secret-id"
  }
}

resource "aws_secretsmanager_secret_rotation" "multiple_rotation_slow" {
  attrs = {
    secret_id = "multiple-rotation-secret"
    rotation_rules = [
      {
        automatically_after_days = 120
      }
    ]
  }
}

resource "aws_secretsmanager_secret_rotation" "multiple_rotation_fast" {
  attrs = {
    secret_id = "multiple-rotation-secret"
    rotation_rules = [
      {
        automatically_after_days = 30
      }
    ]
  }
}
