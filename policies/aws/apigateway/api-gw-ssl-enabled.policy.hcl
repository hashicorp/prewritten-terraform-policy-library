# Policy: APIGateway.2 - API Gateway REST API stages should be configured to use SSL certificates for backend authentication
policy {}

resource_policy "aws_api_gateway_stage" "ssl_backend_auth_required" {
    locals {
        // Safely extract client_certificate_id attribute
        client_cert_id = core::try(attrs.client_certificate_id, null)
        
        // Check if certificate is configured
        has_client_certificate = local.client_cert_id != null && local.client_cert_id != ""
    }

    enforce {
        condition     = local.has_client_certificate
        error_message = "API Gateway stage must have a client certificate configured for backend authentication. Configure 'client_certificate_id' attribute to reference an aws_api_gateway_client_certificate resource. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/apigateway-controls.html#apigateway-2 for more details."
    }
}
