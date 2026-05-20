# EMR.4 - Amazon EMR security configurations should be encrypted in transit.

policy {}

resource_policy "aws_emr_security_configuration" "emr-security-configuration-encryption-transit" {
    locals {
        config = core::jsondecode(attrs.configuration)
    }

    enforce {
        condition = core::try(local.config.EncryptionConfiguration.EnableInTransitEncryption, false)
        error_message = "The EMR security configuration does not have the encryption in transit enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/emr-controls.html#emr-4 for more details."
    }
}
