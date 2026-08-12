# API Gateway routes should specify an authorization type

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure Access Management |

## Description

authorizationType

Authorization type of the API routes

Enum

AWS_IAM, CUSTOM, JWT

No default value

This control checks if Amazon API Gateway routes have an authorization type. The control fails if the API Gateway route doesn't have any authorization type. Optionally, you can provide a custom parameter value if you want the control to pass only if the route uses the authorization type specified in the authorizationType parameter.

API Gateway supports multiple mechanisms for controlling and managing access to your API. By specifying an authorization type, you can restrict access to your API to only authorized users or processes.

This rule is covered by the [api-gwv2-authorization-type-configured](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/apigateway/api-gwv2-authorization-type-configured.policy.hcl) policy.


## Policy Results

```bash
trace:
	# api-gwv2-authorization-type-configured.policytest.hcl...
	running
	# resource.aws_apigatewayv2_route.pass_aws_iam...
	running
	# resource.aws_apigatewayv2_route.pass_aws_iam...
	pass
	# resource.aws_apigatewayv2_route.pass_custom...
	running
	# resource.aws_apigatewayv2_route.pass_custom...
	pass
	# resource.aws_apigatewayv2_route.pass_jwt...
	running
	# resource.aws_apigatewayv2_route.pass_jwt...
	pass
	# resource.aws_apigatewayv2_route.fail_none...
	running
	# resource.aws_apigatewayv2_route.fail_none...
	pass
	# resource.aws_apigatewayv2_route.fail_missing...
	running
	# resource.aws_apigatewayv2_route.fail_missing...
	pass
	# resource.aws_apigatewayv2_route.fail_invalid...
	running
	# resource.aws_apigatewayv2_route.fail_invalid...
	pass
	# api-gwv2-authorization-type-configured.policytest.hcl...
	pass
```

---
