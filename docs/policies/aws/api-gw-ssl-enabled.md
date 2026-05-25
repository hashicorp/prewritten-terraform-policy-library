# API Gateway REST API stages should be configured to use SSL certificates for backend authentication

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether Amazon API Gateway REST API stages have SSL certificates configured. Backend systems use these certificates to authenticate that incoming requests are from API Gateway.

API Gateway REST API stages should be configured with SSL certificates to allow backend systems to authenticate that requests originate from API Gateway.

This rule is covered by the [api-gw-ssl-enabled](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/apigateway/api-gw-ssl-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
	# api-gw-ssl-enabled.policytest.hcl...
	running
	# resource.aws_api_gateway_stage.pass_with_client_certificate...
	running
	# resource.aws_api_gateway_stage.pass_with_client_certificate...
	pass
	# resource.aws_api_gateway_stage.fail_without_client_certificate...
	running
	# resource.aws_api_gateway_stage.fail_without_client_certificate...
	pass
	# resource.aws_api_gateway_stage.fail_with_empty_certificate_id...
	running
	# resource.aws_api_gateway_stage.fail_with_empty_certificate_id...
	pass
	# api-gw-ssl-enabled.policytest.hcl...
	pass
```


---
