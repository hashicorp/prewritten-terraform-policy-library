# Copyright IBM Corp. 2026

# Secrets Manager secrets should have automatic rotation enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "secretsmanager-rotation-enabled-check-enforcement-level" {
  type    = string
  default = "advisory"
}

input "maximumAllowedRotationFrequency" {
  type    = number
  default = 0
}

resource_policy "aws_secretsmanager_secret" "rotation_enabled_check" {
  enforcement_level = input.secretsmanager-rotation-enabled-check-enforcement-level

  locals {
    frequency_input       = input.maximumAllowedRotationFrequency
    frequency_input_valid = local.frequency_input == 0 || (local.frequency_input >= 1 && local.frequency_input <= 365)
  }

  enforce {
    condition     = local.frequency_input_valid
    error_message = "input.maximumAllowedRotationFrequency must be between 1 and 365 when provided (use 0 to leave unset)."
  }

  # Matching by name keeps this evaluable at plan time: aws_secretsmanager_secret_rotation.secret_id
  # accepts a name, ARN, or ID — at plan time, id/arn are "known after apply", but name is known.
  connected "aws_secretsmanager_secret_rotation" {
    connection {
      subject = "name"
      target  = "secret_id"
    }

    cardinality = {
      min_matches = 1
      error_message = "Secret must have automatic rotation enabled. Configure an aws_secretsmanager_secret_rotation resource with rotation_rules.automatically_after_days"
    }

    enforce {
      condition     = core::length(core::try(self.rotation_rules, [])) > 0
      error_message = "Secret rotation must define rotation_rules so that rotation occurs as scheduled"
    }

    enforce {
      condition     = core::try(self.rotation_rules[0].automatically_after_days, 0) == 0 || core::try(self.rotation_rules[0].automatically_after_days, 0) <= input.maximumAllowedRotationFrequency || input.maximumAllowedRotationFrequency == 0
      error_message = "Secret rotation frequency exceeds maximumAllowedRotationFrequency"
    }
  }
}
