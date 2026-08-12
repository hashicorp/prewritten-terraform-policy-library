# API Gateway V2 integrations should use HTTPS for private connections

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether an API Gateway V2 integration has HTTPS enabled for private connections. The control fails if a private connection doesn't have TLS configured.

VPC Links connect API Gateway to private resources. While VPC Links create private connectivity, they don't inherently encrypt data. Configuring TLS ensures use of HTTPS for end-to-end encryption from client through API Gateway to backend. Without TLS, sensitive API traffic flows unencrypted across private connections. HTTPS encryption protects the traffic through private connections from data interception, man-in-the-middle attacks and credential exposure.

This rule is covered by the [apigatewayv2-integration-private-https-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/apigateway/apigatewayv2-integration-private-https-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# apigatewayv2-integration-private-https-enabled.policytest.hcl...
	running
	# resource.aws_apigatewayv2_integration.pass_vpc_link_with_tls...
	running
	# resource.aws_apigatewayv2_integration.pass_vpc_link_with_tls...
	pass
	# resource.aws_apigatewayv2_integration.fail_vpc_link_without_tls...
	running
	# resource.aws_apigatewayv2_integration.fail_vpc_link_without_tls...
	pass
	# resource.aws_apigatewayv2_integration.pass_internet_connection...
	running
	# resource.aws_apigatewayv2_integration.pass_internet_connection...
	pass
	# resource.aws_apigatewayv2_integration.fail_vpc_link_empty_tls...
	running
	# resource.aws_apigatewayv2_integration.fail_vpc_link_empty_tls...
	pass
	# resource.aws_apigatewayv2_integration.pass_default_connection_type...
	running
	# resource.aws_apigatewayv2_integration.pass_default_connection_type...
	pass
	# apigatewayv2-integration-private-https-enabled.policytest.hcl...
	pass
```

---
