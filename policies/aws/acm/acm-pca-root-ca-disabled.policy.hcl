# Policy: PCA.1 - AWS Private CA root certificate authority should be disabled

policy {}

resource_policy "aws_acmpca_certificate_authority" "root_ca_disabled" {
    enforce {
        condition     = core::try(attrs.type, "SUBORDINATE") != "ROOT" || core::try(attrs.enabled, true) == false
        error_message = "AWS Private CA root certificate authority must be disabled. Root CAs should only be used to issue certificates for intermediate CAs and should be stored securely. Set 'enabled = false' on root CAs to comply with this control. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/pca-controls.html#pca-1 for more details."
    }
}
