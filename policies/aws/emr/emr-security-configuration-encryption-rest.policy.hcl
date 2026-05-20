# EMR.3 - Amazon EMR security configurations should be encrypted at rest.

policy {}

resource_policy "aws_emr_security_configuration" "emr-security-configuration-encryption-rest" {
    locals {
        config = core::jsondecode(attrs.configuration)
    }

    enforce {
        condition = core::try(local.config.EncryptionConfiguration.EnableAtRestEncryption, false)
        error_message = "The EMR security configuration does not have the encryption at rest enabled. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/emr-controls.html#emr-3 for more details."
    }
}
