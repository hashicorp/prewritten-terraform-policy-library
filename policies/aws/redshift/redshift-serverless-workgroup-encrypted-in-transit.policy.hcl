# Policy: RedshiftServerless.2 - Require SSL for Redshift Serverless Workgroups

policy {}

input "redshift-serverless-workgroup-encrypted-in-transit-enforcement-level" {
  type = string
  default = "advisory"
}

resource_policy "aws_redshiftserverless_workgroup" "require_ssl_encryption" {
    enforcement_level = input.redshift-serverless-workgroup-encrypted-in-transit-enforcement-level
    locals {
        # Extract config_parameter block (it's a list of maps)
        config_params = core::try(attrs.config_parameter, [])
        
        # Find require_ssl parameter in config_parameter list
        require_ssl_params = [
            for param in local.config_params :
            param if param.parameter_key == "require_ssl"
        ]
        
        # Check if require_ssl is configured
        has_require_ssl = core::length(local.require_ssl_params) > 0
        
        # Get the require_ssl value (default to "false" if not found)
        require_ssl_value = local.has_require_ssl ? local.require_ssl_params[0].parameter_value : "false"
        
        # Check if SSL is properly enabled
        ssl_enabled = local.require_ssl_value == "true"
    }

    enforce {
        condition = local.has_require_ssl
        error_message = "Redshift Serverless workgroup must have 'require_ssl' parameter configured in config_parameter block. Add: config_parameter { parameter_key = \"require_ssl\", parameter_value = \"true\" }. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/redshiftserverless-controls.html#redshiftserverless-2 for more details."
    }

    enforce {
        condition = !local.has_require_ssl || local.ssl_enabled
        error_message = "Redshift Serverless workgroup has require_ssl set to a value other than 'true'. It must be set to 'true' to enforce SSL encryption for data in transit. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/redshiftserverless-controls.html#redshiftserverless-2 for more details."
    }
}
