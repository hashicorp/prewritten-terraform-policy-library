# DMS.11 - DMS endpoints for MongoDB should have an authentication mechanism enabled

policy {}

resource_policy "aws_dms_endpoint" "mongodb_authentication_required" {
  # Only evaluate MongoDB endpoints
  filter = attrs.engine_name == "mongodb"

  locals {
    # Safe access to mongodb_settings block
    mongodb_settings = core::try(attrs.mongodb_settings, null)
    has_mongodb_settings = local.mongodb_settings != null

    # Extract auth_type with safe access
    auth_type = core::try(local.mongodb_settings[0].auth_type, null)
    
    # Extract auth_mechanism with safe access
    auth_mechanism = core::try(local.mongodb_settings[0].auth_mechanism, null)
    
    # Check if authentication is properly configured
    # auth_type should not be "no" and should be set
    has_valid_auth_type = local.auth_type != null && local.auth_type != "no"
    
    # auth_mechanism should be configured (default "default" is acceptable)
    has_auth_mechanism = local.auth_mechanism != null

    auth_type_display = core::try(local.auth_type, "not set")
    
    # Overall compliance check
    is_compliant = local.has_mongodb_settings && local.has_valid_auth_type && local.has_auth_mechanism
  }

  enforce {
    condition = local.has_mongodb_settings
    error_message = "DMS endpoint with engine 'mongodb' must have mongodb_settings block configured for authentication. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/dms-controls.html#dms-11 for more details."
  }

  enforce {
    condition = local.has_valid_auth_type
    error_message = "DMS endpoint must have mongodb_settings.auth_type set to a value other than 'no'. Current value: ${local.auth_type_display} . Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/dms-controls.html#dms-11 for more details."
  }

  enforce {
    condition = local.has_auth_mechanism
    error_message = "DMS endpoint must have mongodb_settings.auth_mechanism configured. Use 'default', 'mongodb_cr', or 'scram_sha_1' . Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/dms-controls.html#dms-11 for more details."
  }
}