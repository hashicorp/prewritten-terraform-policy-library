# Copyright IBM Corp. 2026

# CloudTrail.2 - CloudTrail should have encryption at-rest enabled.

policy {}

resource_policy "aws_cloudtrail" "encryption-at-rest" {
    enforce {
        condition = core::try(attrs.kms_key_id, "") != ""
        error_message = "CloudTrail is not encrypted at rest. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/cloudtrail-controls.html#cloudtrail-2 for more details."
    }
}
