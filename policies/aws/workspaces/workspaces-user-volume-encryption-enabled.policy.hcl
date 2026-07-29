# Copyright IBM Corp. 2026

# WorkSpaces.1 - WorkSpaces user volumes should be encrypted at rest.

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, < 7.0.0"
    }
  }
}

input "workspaces-user-volume-encryption-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_workspaces_workspace" "user-volume-encrypted" {
    enforcement_level = input.workspaces-user-volume-encryption-enabled-enforcement-level
    enforce {
        condition = core::try(attrs.user_volume_encryption_enabled, false)
        error_message = "The WorkSpaces user volume is not encrypted at rest. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/workspaces-controls.html#workspaces-1 for more details."
    }
}
