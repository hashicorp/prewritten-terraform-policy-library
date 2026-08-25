# Copyright IBM Corp. 2026

# CodeBuild Bitbucket source repository URLs should not contain sensitive credentials

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 7.0.0"
    }
  }
}

input "codebuild-project-source-repo-url-check-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_codebuild_project" "bitbucket_credentials_check" {
    enforcement_level = input.codebuild-project-source-repo-url-check-enforcement-level

    locals {
        # Primary source
        primary_source_raw = core::try(attrs.source, null)
        primary_source = local.primary_source_raw != null ? local.primary_source_raw : []
        primary_type     = core::try(local.primary_source[0].type, "")
        primary_location = core::try(local.primary_source[0].location, "")

        primary_has_embedded_credentials = (
            local.primary_type == "BITBUCKET" &&
            core::try(core::regex("://[^/@]+@", local.primary_location), "") != ""
        )

        # Secondary sources
        secondary_sources = core::try(attrs.secondary_sources, [])

        secondary_credential_violations = [
            for source in local.secondary_sources :
            source
            if core::try(source.type, "") == "BITBUCKET" &&
               core::try(
                   core::regex("://[^/@]+@", core::try(source.location, "")),
                   ""
               ) != ""
        ]
    }

    enforce {
        condition = !local.primary_has_embedded_credentials
        error_message = "CodeBuild project Bitbucket source.location must not contain embedded credentials (user:password@host or user:token@host)."
    }

    enforce {
        condition = core::length(local.secondary_credential_violations) == 0
        error_message = "CodeBuild project secondary Bitbucket source locations must not contain embedded credentials (user:password@host or user:token@host)."
    }
}
