# Copyright IBM Corp. 2026

# Policy: DMS.12 - DMS endpoints for Redis OSS should have TLS enabled

policy {}

input "dms-redis-tls-enabled-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_dms_endpoint" "redis_tls_enabled" {
    enforcement_level = input.dms-redis-tls-enabled-enforcement-level
    # Filter to only Redis endpoints
    # Only evaluate endpoints that have redis_settings configured
    filter = core::try(attrs.redis_settings, null) != null && core::length(core::try(attrs.redis_settings, [])) > 0

    locals {
        # Extract redis_settings (it's a list/block, so we need [0])
        redis_config = core::try(attrs.redis_settings[0], null)
        
        # Get ssl_security_protocol value
        # Default is "ssl-encryption" if not specified, which is compliant
        ssl_protocol = core::try(local.redis_config.ssl_security_protocol, "ssl-encryption")
        
        # Check if TLS is enabled (not using plaintext)
        tls_enabled = local.ssl_protocol == "ssl-encryption"
    }

    enforce {
        condition = local.tls_enabled
        error_message = "DMS endpoint for Redis must have TLS enabled. Current ssl_security_protocol is '${local.ssl_protocol}' but must be 'ssl-encryption' (not 'plaintext'). TLS provides end-to-end security for data in transit during migration. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/dms-controls.html#dms-12 for more details. "
    }
}
