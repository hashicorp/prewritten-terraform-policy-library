# Copyright IBM Corp. 2026

# Policy: Macie.2 - Macie automated sensitive data discovery should be enabled

policy {}

resource_policy "aws_macie2_account" "automated_discovery_enabled" {
    filter = core::try(attrs.status, null) != null

    enforce {
        condition = core::try(attrs.status, "") == "ENABLED"
        error_message = "Amazon Macie must be enabled (status = \"ENABLED\") on the aws_macie2_account resource so that automated sensitive data discovery can be configured. Note: the Terraform AWS provider does not expose automated sensitive data discovery configuration; after enabling Macie, enable automated discovery via the AWS Console (Macie > Settings > Automated discovery) or `aws macie2 update-automated-discovery-configuration`. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/macie-controls.html#macie-2 for more details."
    }
}
