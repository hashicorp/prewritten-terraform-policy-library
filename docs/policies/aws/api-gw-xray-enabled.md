# API Gateway REST API stages should have AWS X-Ray tracing enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether AWS X-Ray active tracing is enabled for your Amazon API Gateway REST API stages.

X-Ray active tracing enables a more rapid response to performance changes in the underlying infrastructure. Changes in performance could result in a lack of availability of the API. X-Ray active tracing provides real-time metrics of user requests that flow through your API Gateway REST API operations and connected services.

This rule is covered by the [api-gw-xray-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/apigateway/api-gw-xray-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# api-gw-xray-enabled.policytest.hcl...
	running
	# resource.aws_api_gateway_stage.pass_xray_enabled...
	running
	# resource.aws_api_gateway_stage.pass_xray_enabled...
	pass
	# resource.aws_api_gateway_stage.fail_xray_disabled...
	running
	# resource.aws_api_gateway_stage.fail_xray_disabled...
	pass
	# resource.aws_api_gateway_stage.fail_xray_not_specified...
	running
	# resource.aws_api_gateway_stage.fail_xray_not_specified...
	pass
	# api-gw-xray-enabled.policytest.hcl...
	pass
```

---
