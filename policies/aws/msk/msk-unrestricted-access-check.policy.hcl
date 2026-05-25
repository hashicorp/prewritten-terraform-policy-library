# Policy: MSK.6 - MSK clusters should disable unauthenticated access

policy {}

resource_policy "aws_msk_cluster" "disable_unauthenticated_access" {
    locals {
        # Safe access to client_authentication block
        client_auth = core::try(attrs.client_authentication[0], attrs.client_authentication, null)
        has_client_auth = local.client_auth != null
        
        # Check if unauthenticated access is explicitly enabled
        unauthenticated_value = core::try(local.client_auth.unauthenticated, false)
        unauthenticated_enabled = local.has_client_auth && local.unauthenticated_value
        
        # Check for SASL authentication mechanisms
        sasl_config = core::try(local.client_auth.sasl[0], local.client_auth.sasl, null)
        has_sasl = local.sasl_config != null
        iam_enabled = local.has_sasl && core::try(local.sasl_config.iam == true, false)
        scram_enabled = local.has_sasl && core::try(local.sasl_config.scram == true, false)
        
        # Check for TLS authentication
        tls_config = core::try(local.client_auth.tls[0], local.client_auth.tls, null)
        has_tls = local.tls_config != null
        tls_cert_arns = core::try(local.tls_config.certificate_authority_arns, [])
        tls_enabled = local.has_tls && core::length(local.tls_cert_arns) > 0
        
        # Check if at least one authentication mechanism is enabled
        has_auth_mechanism = local.iam_enabled || local.scram_enabled || local.tls_enabled
    }
    
    enforce {
        condition = !local.unauthenticated_enabled
        error_message = "MSK cluster must not have unauthenticated access enabled. Set client_authentication.unauthenticated to false or omit it entirely. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/msk-controls.html#msk-6 for more details."
    }
    
    enforce {
        condition = local.has_auth_mechanism
        error_message = "MSK cluster must have at least one authentication mechanism enabled (IAM, SASL/SCRAM, or TLS). Configure client_authentication.sasl.iam, client_authentication.sasl.scram, or client_authentication.tls. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/msk-controls.html#msk-6 for more details."
    }
}