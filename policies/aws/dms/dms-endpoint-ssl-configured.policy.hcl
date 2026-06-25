# Copyright IBM Corp. 2026

# Policy: DMS.9 - DMS endpoints should use SSL

policy {}

input "dms-endpoint-ssl-configured-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_dms_endpoint" "ssl_mode_required" {
  enforcement_level = input.dms-endpoint-ssl-configured-enforcement-level
  locals {
    valid_ssl_modes = ["require", "verify-ca", "verify-full"]
    ssl_mode_raw    = core::try(attrs.ssl_mode, null)
    ssl_mode        = local.ssl_mode_raw == null ? "" : local.ssl_mode_raw
    is_compliant    = core::contains(local.valid_ssl_modes, local.ssl_mode)
  }

  enforce {
    condition     = local.is_compliant
    error_message = "Attribute 'ssl_mode' must be set to one of: require, verify-ca, verify-full for 'aws_dms_endpoint' resources. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/dms-controls.html#dms-9 for more details."
  }
}
