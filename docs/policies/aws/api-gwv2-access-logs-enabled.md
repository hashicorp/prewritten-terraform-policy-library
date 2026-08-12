# Access logging should be configured for API Gateway V2 Stages

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks if Amazon API Gateway V2 stages have access logging configured. This control fails if access log settings aren't defined.

API Gateway access logs provide detailed information about who has accessed your API and how the caller accessed the API. These logs are useful for applications such as security and access audits and forensics investigation. Enable these access logs to analyze traffic patterns and to troubleshoot issues.

For additional best practices, see Monitoring REST APIs in the API Gateway Developer Guide.

This rule is covered by the [api-gwv2-access-logs-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/apigateway/api-gwv2-access-logs-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# api-gwv2-access-logs-enabled.policytest.hcl...
	running
	# resource.aws_apigatewayv2_stage.pass_complete_access_log_settings...
	running
	# resource.aws_apigatewayv2_stage.pass_complete_access_log_settings...
	pass
	# resource.aws_apigatewayv2_stage.fail_missing_access_log_settings...
	running
	# resource.aws_apigatewayv2_stage.fail_missing_access_log_settings...
	pass
	# resource.aws_apigatewayv2_stage.fail_missing_destination_arn...
	running
	# resource.aws_apigatewayv2_stage.fail_missing_destination_arn...
	pass
	# resource.aws_apigatewayv2_stage.fail_missing_format...
	running
	# resource.aws_apigatewayv2_stage.fail_missing_format...
	pass
	# resource.aws_apigatewayv2_stage.fail_empty_access_log_settings...
	running
	# resource.aws_apigatewayv2_stage.fail_empty_access_log_settings...
	pass
	# resource.aws_apigatewayv2_stage.pass_http_api_with_logging...
	running
	# resource.aws_apigatewayv2_stage.pass_http_api_with_logging...
	pass
	# resource.aws_apigatewayv2_stage.pass_websocket_api_with_logging...
	running
	# resource.aws_apigatewayv2_stage.pass_websocket_api_with_logging...
	pass
	# api-gwv2-access-logs-enabled.policytest.hcl...
	pass
```

---
