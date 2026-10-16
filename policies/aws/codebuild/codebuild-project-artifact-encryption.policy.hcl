# Copyright IBM Corp. 2026

# CodeBuild projects should encrypt all artifacts

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "codebuild-project-artifact-encryption-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_codebuild_project" "codebuild_project_artifact_encryption" {
  locals {
    primary_raw = core::try(attrs.artifacts, null)
    primary     = local.primary_raw != null ? local.primary_raw : []

    secondary_raw = core::try(attrs.secondary_artifacts, null)
    secondary     = local.secondary_raw != null ? local.secondary_raw : []

    unencrypted_primary = [for a in local.primary : a
      if core::try(a.type, "") != "NO_ARTIFACTS" &&
    (core::try(a.encryption_disabled, null) == null ? false : core::try(a.encryption_disabled, null)) == true]

    unencrypted_secondary = [for a in local.secondary : a
      if core::try(a.type, "") != "NO_ARTIFACTS" &&
    (core::try(a.encryption_disabled, null) == null ? false : core::try(a.encryption_disabled, null)) == true]

    all_artifacts_encrypted = core::length(local.unencrypted_primary) == 0 && core::length(local.unencrypted_secondary) == 0
  }

  enforcement_level = input.codebuild-project-artifact-encryption-enforcement-level
  enforce {
    condition     = local.all_artifacts_encrypted
    error_message = "AWS CodeBuild project must have encryption enabled for all artifacts. Set 'encryption_disabled' to false or omit it to enable encryption"
  }
}
