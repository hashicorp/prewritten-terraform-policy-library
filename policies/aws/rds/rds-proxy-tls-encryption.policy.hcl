# Copyright IBM Corp. 2026

# RDS.43 - RDS DB proxies should require TLS encryption for connections.

policy {}

resource_policy "aws_db_proxy" "require_tls_enabled" {
    enforce {
        condition = core::try(attrs.require_tls, false) == true
        error_message = "RDS DB proxy must set require_tls = true to require TLS encryption for connections. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/rds-controls.html#rds-43 for more details."
    }
}
