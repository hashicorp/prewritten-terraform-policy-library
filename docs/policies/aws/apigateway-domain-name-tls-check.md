# Policy: APIGateway.11 - API Gateway domain names should use recommended security policies

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Security |

## Description

API Gateway domain name must have security_policy explicitly configured. Set security_policy to one of the allowed values (SecurityPolicy_TLS13_1_3_2025_09, SecurityPolicy_TLS13_1_3_FIPS_2025_09, SecurityPolicy_TLS13_1_2_PFS_PQ_2025_09, SecurityPolicy_TLS13_2025_EDGE, SecurityPolicy_TLS12_PFS_2025_EDGE). Refer to https://docs.aws.amazon.com/securityhub/latest/userguide/apigateway-controls.html#apigateway-11 for more details.

This rule is covered by the [apigateway-domain-name-tls-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/apigateway/apigateway-domain-name-tls-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # apigateway-domain-name-tls-check.policytest.hcl... 
      running
      # resource.aws_api_gateway_domain_name.pass_security_policy_tls13_1_3_2025_09...
       running
      # resource.aws_api_gateway_domain_name.pass_security_policy_tls13_1_3_2025_09...
       pass
      # resource.aws_api_gateway_domain_name.fail_no_security_policy... 
      running
      # resource.aws_api_gateway_domain_name.fail_no_security_policy... 
      pass
      # resource.aws_api_gateway_domain_name.fail_tls_1_0_deprecated... 
      running
      # resource.aws_api_gateway_domain_name.fail_tls_1_0_deprecated... 
      pass
      # resource.aws_api_gateway_domain_name.fail_tls_1_0_alt_format... 
      running
      # resource.aws_api_gateway_domain_name.fail_tls_1_0_alt_format... 
      pass
      # resource.aws_api_gateway_domain_name.fail_unknown_policy... 
      running
      # resource.aws_api_gateway_domain_name.fail_unknown_policy... 
      pass
      # apigateway-domain-name-tls-check.policytest.hcl... 
      pass

```

---
