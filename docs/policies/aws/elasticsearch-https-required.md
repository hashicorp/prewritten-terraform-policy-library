# Connections to Elasticsearch domains should be encrypted using the latest TLS security policy

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This controls checks whether an Elasticsearch domain endpoint is configured to use the latest TLS security policy. The control fails if the Elasticsearch domain endpoint isn't configured to use the latest supported policy or if HTTPs isn't enabled. The current latest supported TLS security policy is Policy-Min-TLS-1-2-PFS-2023-10.

HTTPS (TLS) can be used to help prevent potential attackers from using person-in-the-middle or similar attacks to eavesdrop on or manipulate network traffic. Only encrypted connections over HTTPS (TLS) should be allowed. Encrypting data in transit can affect performance. You should test your application with this feature to understand the performance profile and the impact of TLS. TLS 1.2 provides several security enhancements over previous versions of TLS.

This rule is covered by the [elasticsearch-https-required](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/elasticsearch/elasticsearch-https-required.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elasticsearch-https-required.policytest.hcl... running
      # resource.aws_elasticsearch_domain.compliant... running
      # resource.aws_elasticsearch_domain.compliant... pass
      # resource.aws_elasticsearch_domain.compliant_default... running
      # resource.aws_elasticsearch_domain.compliant_default... pass
      # resource.aws_elasticsearch_domain.no_https... running
      # resource.aws_elasticsearch_domain.no_https... pass
      # resource.aws_elasticsearch_domain.old_tls... running
      # resource.aws_elasticsearch_domain.old_tls... pass
      # resource.aws_elasticsearch_domain.non_compliant... running
      # resource.aws_elasticsearch_domain.non_compliant... pass
      # resource.aws_elasticsearch_domain.no_tls_policy... running
      # resource.aws_elasticsearch_domain.no_tls_policy... pass
      # elasticsearch-https-required.policytest.hcl... pass
```

---
