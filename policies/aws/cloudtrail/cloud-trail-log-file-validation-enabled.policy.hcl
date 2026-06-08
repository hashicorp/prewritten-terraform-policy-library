# Copyright IBM Corp. 2026

# CloudTrail.4 - CloudTrail log file validation should be enabled.

policy {}

resource_policy "aws_cloudtrail" "log-file-validation" {
    enforce {
        condition = core::try(attrs.enable_log_file_validation, false)
        error_message = "CloudTrail log file validation is not enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/cloudtrail-controls.html#cloudtrail-4 for more details."
    }
}
