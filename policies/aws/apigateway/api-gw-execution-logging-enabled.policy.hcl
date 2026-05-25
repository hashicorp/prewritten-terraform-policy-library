# Policy: APIGateway.1 - API Gateway REST and WebSocket API execution logging should be enabled
policy {}

resource_policy "aws_api_gateway_stage" "access_logging_enabled" {
    locals {
        # Check if access logging is configured
        access_log_settings = core::try(attrs.access_log_settings, null)
        has_access_log = local.access_log_settings != null ? core::length(local.access_log_settings) > 0 : false
        
        # Verify destination ARN is set
        has_destination = local.has_access_log ? core::try(local.access_log_settings[0].destination_arn, "") != "" : false
    }

    enforce {
        condition = local.has_access_log
        error_message = "API Gateway REST API stage must have access_log_settings configured. Configure access logging with CloudWatch Logs destination. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/apigateway-controls.html#apigateway-1 for more details."
    }

    enforce {
        condition = local.has_destination
        error_message = "API Gateway REST API stage access_log_settings must specify a destination_arn for CloudWatch Logs. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/apigateway-controls.html#apigateway-1 for more details."
    }
}

# Policy for API Gateway WebSocket API stages (v2)
resource_policy "aws_apigatewayv2_stage" "execution_logging_enabled" {
    locals {
        # Check if default route settings exist and have logging configured
        default_route_settings = core::try(attrs.default_route_settings, null)
        has_default_route_settings = local.default_route_settings != null ? core::length(local.default_route_settings) > 0 : false
        
        # For WebSocket APIs, logging_level should be ERROR or INFO
        logging_level = local.has_default_route_settings ? core::try(local.default_route_settings[0].logging_level, "OFF") : "OFF"

        # Valid logging levels come directly from the policy input parameter
        allowed_logging_levels = ["ERROR", "INFO"]
        is_valid_level = core::contains(local.allowed_logging_levels, local.logging_level)
        
        # Also check if access logging is configured
        access_log_settings = core::try(attrs.access_log_settings, null)
        has_access_log = local.access_log_settings != null ? core::length(local.access_log_settings) > 0 : false
        has_destination = local.has_access_log ? core::try(local.access_log_settings[0].destination_arn, "") != "" : false
    }

    enforce {
        condition = local.has_default_route_settings
        error_message = "API Gateway v2 stage must have default_route_settings configured for logging. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/apigateway-controls.html#apigateway-1 for more details."
    }

    enforce {
        condition = local.is_valid_level
        error_message = "API Gateway v2 stage logging_level must match one of the allowed values ('ERROR', 'INFO'). Configure default_route_settings.logging_level. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/apigateway-controls.html#apigateway-1 for more details."
    }

    enforce {
        condition = local.has_access_log
        error_message = "API Gateway v2 stage must have access_log_settings configured. Configure access logging with CloudWatch Logs destination. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/apigateway-controls.html#apigateway-1 for more details."
    }

    enforce {
        condition = local.has_destination
        error_message = "API Gateway v2 stage access_log_settings must specify a destination_arn for CloudWatch Logs. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/apigateway-controls.html#apigateway-1 for more details."
    }
}

# Policy for API Gateway Method Settings (REST API execution logging)
resource_policy "aws_api_gateway_method_settings" "execution_logging_level" {
    locals {
        # Check if settings block exists
        settings = core::try(attrs.settings, null)
        has_settings = local.settings != null ? core::length(local.settings) > 0 : false
        
        # Get logging level from settings
        logging_level = local.has_settings ? core::try(local.settings[0].logging_level, "OFF") : "OFF"

        # Valid logging levels come directly from the policy input parameter
        allowed_logging_levels = ["ERROR", "INFO"]
        is_valid_level = core::contains(local.allowed_logging_levels, local.logging_level)
    }

    enforce {
        condition = local.has_settings
        error_message = "API Gateway method settings must have settings block configured. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/apigateway-controls.html#apigateway-1 for more details."
    }

    enforce {
        condition = local.is_valid_level
        error_message = "API Gateway method settings logging_level must match one of the allowed values ('ERROR', 'INFO'). Set settings.logging_level to enable execution logging. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/apigateway-controls.html#apigateway-1 for more details."
    }
}
