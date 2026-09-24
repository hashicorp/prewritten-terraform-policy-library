# Copyright IBM Corp. 2026

# Secrets Manager secrets configured with automatic rotation should rotate successfully

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "secretsmanager-scheduled-rotation-success-check-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_secretsmanager_secret" "rotation_success_check" {
  enforcement_level = input.secretsmanager-scheduled-rotation-success-check-enforcement-level

  # secret_id accepts a name or ARN. At plan time, name is the reliably known value.
  connected "aws_secretsmanager_secret_rotation" {
    connection {
      subject = "name"
      target  = "secret_id"
    }

    cardinality = {
      min_matches = 1
    }

    enforce {
      condition     = core::length(core::try(self.rotation_rules, [])) > 0
      error_message = "Secrets Manager secret rotation must define rotation_rules so that rotation occurs as scheduled"
    }

    enforce {
      condition     = core::try(self.rotation_rules[0].automatically_after_days, 0) > 0 || core::try(self.rotation_rules[0].schedule_expression, "") != ""
      error_message = "Secrets Manager secret rotation_rules must set either 'automatically_after_days' or 'schedule_expression' so that rotation occurs as scheduled"
    }

    enforce {
      condition     = core::try(self.rotation_rules[0].automatically_after_days, 0) == 0 || core::try(self.rotation_rules[0].automatically_after_days, 0) <= 90
      error_message = "Secrets Manager secret rotation 'automatically_after_days' must be 90 or less so the secret rotates frequently enough to satisfy the scheduled-rotation requirement"
    }
  }

  enforce {
    condition     = true
    error_message = "Secrets Manager secret must have an associated 'aws_secretsmanager_secret_rotation' resource configured for automatic rotation"
  }
}
