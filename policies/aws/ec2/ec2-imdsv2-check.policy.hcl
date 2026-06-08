# Copyright IBM Corp. 2026

# EC2.8 - EC2 instances should use Instance Metadata Service Version 2 (IMDSv2).

policy {}

resource_policy "aws_ec2_instance_metadata_defaults" "imds_v2" {
    enforce {
        condition = core::try(attrs.http_tokens, "no-preference") != "optional"
        error_message = "IMDSv2 is not enabled on the instance. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/ec2-controls.html#ec2-8 for more details."
    }
}