# Policy: APIGateway.5 - API Gateway REST API cache data should be encrypted at rest

policy {}

resource_policy "aws_api_gateway_method_settings" "cache_encryption_required" {
    # Only evaluate method settings that have caching enabled
    filter = core::try(attrs.settings[0].caching_enabled, false) == true

    locals {
        # Safely extract cache encryption setting
        cache_data_encrypted = core::try(attrs.settings[0].cache_data_encrypted, false)
        
        # Get method path for error message
        method_path = core::try(attrs.method_path, "unknown")
        
        # Get stage name for error message
        stage_name = core::try(attrs.stage_name, "unknown")
    }

    enforce {
        condition = local.cache_data_encrypted == true
        error_message = "API Gateway method '${local.method_path}' in stage '${local.stage_name}' has caching enabled but cache data is not encrypted. Enable cache encryption by setting cache_data_encrypted = true in the method settings. Refer this https://docs.aws.amazon.com/securityhub/latest/userguide/apigateway-controls.html#apigateway-5 for more details."
    }
}
