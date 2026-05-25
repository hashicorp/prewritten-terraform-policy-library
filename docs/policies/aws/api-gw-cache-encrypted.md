# API Gateway REST API cache data should be encrypted at rest

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data at rest |

## Description

This control checks whether all methods in API Gateway REST API stages that have cache enabled are encrypted. The control fails if any method in an API Gateway REST API stage is configured to cache and the cache is not encrypted. Security Hub CSPM evaluates the encryption of a particular method only when caching is enabled for that method.

Encrypting data at rest reduces the risk of data stored on disk being accessed by a user not authenticated to AWS. It adds another set of access controls to limit unauthorized users ability access the data. For example, API permissions are required to decrypt the data before it can be read.

API Gateway REST API caches should be encrypted at rest for an added layer of security.

This rule is covered by the [api-gw-cache-encrypted](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/apigateway/api-gw-cache-encrypted.policy.hcl) policy.


## Policy Results

```bash
trace:
	# api-gw-cache-encrypted.policytest.hcl...
	running
	# resource.aws_api_gateway_method_settings.pass_caching_enabled_with_encryption...
	running
	# resource.aws_api_gateway_method_settings.pass_caching_enabled_with_encryption...
	pass
	# resource.aws_api_gateway_method_settings.fail_caching_enabled_without_encryption...
	running
	# resource.aws_api_gateway_method_settings.fail_caching_enabled_without_encryption...
	pass
	# resource.aws_api_gateway_method_settings.filtered_caching_disabled...
	running
	# resource.aws_api_gateway_method_settings.filtered_caching_disabled...
	pass
	# resource.aws_api_gateway_method_settings.fail_explicit_false_encryption...
	running
	# resource.aws_api_gateway_method_settings.fail_explicit_false_encryption...
	pass
	# resource.aws_api_gateway_method_settings.fail_encryption_not_specified...
	running
	# resource.aws_api_gateway_method_settings.fail_encryption_not_specified...
	pass
	# api-gw-cache-encrypted.policytest.hcl...
	pass
```

---
