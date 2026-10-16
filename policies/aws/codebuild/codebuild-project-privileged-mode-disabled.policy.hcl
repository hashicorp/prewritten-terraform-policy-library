# Copyright IBM Corp. 2026

# CodeBuild project environments should not have privileged mode enabled

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "codebuild-project-privileged-mode-disabled-enforcement-level" {
  type    = string
  default = "advisory"
}

input "codebuild-project-privileged-mode-disabled-exempted_projects" {
  type        = list(string)
  description = "List of CodeBuild project names that are allowed to have privileged_mode set to true."
  default     = []
}

resource_policy "aws_codebuild_project" "privileged_mode_disabled" {
  locals {
    project_name = core::try(attrs.name, "")
    is_exempted  = core::contains(input.codebuild-project-privileged-mode-disabled-exempted_projects, local.project_name)

    environment_raw = core::try(attrs.environment, null)
    environment     = local.environment_raw != null ? local.environment_raw : []
    has_environment = core::length(local.environment) > 0

    privileged_mode_raw = local.has_environment ? core::try(local.environment[0].privileged_mode, null) : null
    privileged_mode     = local.privileged_mode_raw == null ? false : local.privileged_mode_raw

    is_compliant = local.is_exempted || !local.has_environment || local.privileged_mode == false
  }

  enforcement_level = input.codebuild-project-privileged-mode-disabled-enforcement-level
  enforce {
    condition     = local.is_compliant
    error_message = "AWS CodeBuild project has privileged mode enabled. Privileged mode should be disabled unless required for specific use cases like Docker builds. Add the project name to the 'exempted_projects' input if this is intentional."
  }
}
