# Copyright IBM Corp. 2026

# Policy: SecretsManager.1 - Secrets Manager secrets should have automatic rotation enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "secretsmanager-rotation-enabled-check-enforcement-level" {
  type = string
  default = "advisory"
}

input "maximumAllowedRotationFrequency" {
  type    = number
  default = 0
}

resource_policy "aws_secretsmanager_secret" "rotation_frequency_input_valid" {
  enforcement_level = input.secretsmanager-rotation-enabled-check-enforcement-level
  locals {
    frequency_input       = input.maximumAllowedRotationFrequency
    frequency_input_valid = local.frequency_input == 0 || (local.frequency_input >= 1 && local.frequency_input <= 365)
  }

  # Validate input parameter range (Config rule allows 1-365; 0 means "not set" in this policy).
  enforce {
    condition     = local.frequency_input_valid
    error_message = "input.maximumAllowedRotationFrequency must be between 1 and 365 when provided (use 0 to leave unset)."
  }
}

resource_policy "aws_secretsmanager_secret" "rotation_enabled_check" {
  enforcement_level = input.secretsmanager-rotation-enabled-check-enforcement-level

  connected "aws_secretsmanager_secret_rotation" {
    min_instances = 1

    # Match by name so the connection remains known during planning, when the
    # secret's generated id and arn are not yet available.
    connection {
      subject   = "name"
      connected = "secret_id"
    }

    filter = !(
      input.maximumAllowedRotationFrequency > 0 &&
      core::length(core::try(connected.aws_secretsmanager_secret_rotation.rotation_rules, [])) > 0 &&
      core::try(connected.aws_secretsmanager_secret_rotation.rotation_rules[0].automatically_after_days, 0) > 0 &&
      core::try(connected.aws_secretsmanager_secret_rotation.rotation_rules[0].automatically_after_days, 0) > input.maximumAllowedRotationFrequency
    )
  }
}
