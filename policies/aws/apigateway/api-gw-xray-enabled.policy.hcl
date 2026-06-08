# Copyright IBM Corp. 2026

# APIGateway.3: API Gateway REST API stages should have AWS X-Ray tracing enabled
policy {}

resource_policy "aws_api_gateway_stage" "xray_tracing_required" {
    locals {
        # Safe access to xray_tracing_enabled attribute with default false
        xray_enabled = core::try(attrs.xray_tracing_enabled, false)
    }

    enforce {
        condition     = local.xray_enabled == true
        error_message = "API Gateway stage must have X-Ray tracing enabled. Set 'xray_tracing_enabled = true' to enable active tracing for performance monitoring and rapid response to infrastructure changes. Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/apigateway-controls.html#apigateway-3 for more details."
    }
}
