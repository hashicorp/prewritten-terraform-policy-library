# Copyright IBM Corp. 2026

# CodeBuild.7: CodeBuild report group exports should be encrypted at rest

policy {}

resource_policy "aws_codebuild_report_group" "encryption_required" {
    # Filter to only report groups that export to S3
    filter = attrs.export_config != null && core::length(attrs.export_config) > 0 && core::try(attrs.export_config[0].type, "") == "S3"

    locals {
        # Extract export configuration
        export_config = core::try(attrs.export_config[0], null)
        s3_destination = core::try(local.export_config.s3_destination, null)
        
        # Check encryption settings
        has_s3_destination = local.s3_destination != null && core::length(local.s3_destination) > 0
        encryption_key = core::try(local.s3_destination[0].encryption_key, "")
        encryption_disabled = core::try(local.s3_destination[0].encryption_disabled, false)
        
        # Validation checks
        has_encryption_key = local.encryption_key != ""
        is_encryption_enabled = !local.encryption_disabled
    }

    # Enforce: S3 destination must be configured
    enforce {
        condition = local.has_s3_destination
        error_message = "CodeBuild report group exports to S3 but s3_destination is not properly configured. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/codebuild-controls.html#codebuild-7 for more details."
    }

    # Enforce: Encryption must not be explicitly disabled
    enforce {
        condition = local.is_encryption_enabled
        error_message = "CodeBuild report group has encryption explicitly disabled (encryption_disabled = true). Encryption must be enabled for S3 exports. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/codebuild-controls.html#codebuild-7 for more details."
    }

    # Enforce: KMS encryption key must be specified
    enforce {
        condition = local.has_encryption_key
        error_message = "CodeBuild report group is missing encryption_key for S3 export. Specify a KMS key ARN to encrypt report data at rest. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/codebuild-controls.html#codebuild-7 for more details."
    }
}
