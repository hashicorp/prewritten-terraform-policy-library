# Copyright IBM Corp. 2026

# Policy: APIGateway.8 - API Gateway routes should specify an authorization type

policy {}

resource_policy "aws_apigatewayv2_route" "authorization_type_configured" {
  
  locals {
    # Safe access to authorization_type attribute
    auth_type = core::try(attrs.authorization_type, "NONE")
    
    # Accepted authorization types are driven directly by the input list
    allowed_auth_types = ["AWS_IAM", "CUSTOM", "JWT"]
    
    # Check if authorization type is configured (not NONE)
    has_authorization = local.auth_type != "NONE"
    
    # Check if authorization type matches one of the configured input values
    is_valid_type = core::contains(local.allowed_auth_types, local.auth_type)
  }

  # Enforce: Route must have authorization type configured (not NONE)
  enforce {
    condition = local.has_authorization && local.is_valid_type
    error_message = "API Gateway route must have an authorization type configured. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/apigateway-controls.html#apigateway-8 for more details."
  }
}
