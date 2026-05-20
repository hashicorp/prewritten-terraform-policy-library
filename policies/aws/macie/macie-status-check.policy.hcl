// Policy : Macie.1 -  Amazon Macie should be enabled

policy {}

resource_policy "aws_macie2_account" "macie_enabled" {
    locals {
        macie_status = core::try(attrs.status, "")
        remediation_text = "Set status = ENABLED in the aws_macie2_account resource to enable Macie and start all Macie activities for the account."
        
        is_enabled = local.macie_status == "ENABLED"
    }

    enforce {
        condition = local.is_enabled
        error_message = "Amazon Macie must be enabled for the account. Status is '${local.macie_status}' but must be ENABLED. ${local.remediation_text} Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/macie-controls.html#macie-1 for more details."
    }
}
