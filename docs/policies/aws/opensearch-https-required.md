# Connections to OpenSearch domains should be encrypted using the latest TLS security policy

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This controls checks whether an Amazon OpenSearch Service domain endpoint is configured to use the latest TLS security policy. The control fails if the OpenSearch domain endpoint isn't configured to use the latest supported policy or if HTTPs isn't enabled.

HTTPS (TLS) can be used to help prevent potential attackers from using person-in-the-middle or similar attacks to eavesdrop on or manipulate network traffic. Only encrypted connections over HTTPS (TLS) should be allowed. Encrypting data in transit can affect performance. You should test your application with this feature to understand the performance profile and the impact of TLS. TLS 1.2 provides several security enhancements over previous versions of TLS.

This rule is covered by the [opensearch-https-required](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/opensearch/opensearch-https-required.policy.hcl) policy.

## Policy Results

```bash
trace:
      # opensearch-https-required.policytest.hcl... running
      # resource.aws_opensearch_domain.compliant... running
      # resource.aws_opensearch_domain.compliant... pass
      # resource.aws_opensearch_domain.compliant... running
      # resource.aws_opensearch_domain.compliant... pass
      # resource.aws_opensearch_domain.no_endpoint_options... running
      # resource.aws_opensearch_domain.no_endpoint_options... pass
      # resource.aws_opensearch_domain.no_https... running
      # resource.aws_opensearch_domain.no_https... pass
      # resource.aws_opensearch_domain.old_tls... running
      # resource.aws_opensearch_domain.old_tls... pass
      # resource.aws_opensearch_domain.no_tls_policy... running
      # resource.aws_opensearch_domain.no_tls_policy... pass
      # opensearch-https-required.policytest.hcl... pass
```

---
