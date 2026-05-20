# Elasticsearch domains should have encryption at-rest enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether Elasticsearch domains have encryption at rest configuration enabled. The check fails if encryption at rest is not enabled.

For an added layer of security for your sensitive data in OpenSearch, you should configure your OpenSearch to be encrypted at rest. Elasticsearch domains offer encryption of data at rest. The feature uses AWS KMS to store and manage your encryption keys. To perform the encryption, it uses the Advanced Encryption Standard algorithm with 256-bit keys (AES-256).

To learn more about OpenSearch encryption at rest, see Encryption of data at rest for Amazon OpenSearch Service in the Amazon OpenSearch Service Developer Guide.

Certain instance types, such as t.small and t.medium, don't support encryption of data at rest. For details, see Supported instance types in the Amazon OpenSearch Service Developer Guide.

This rule is covered by the [elasticsearch-encrypted-at-rest](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/elasticsearch/elasticsearch-encrypted-at-rest.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elasticsearch-encrypted-at-rest.policytest.hcl... running
      # resource.aws_elasticsearch_domain.pass_encrypted... running
      # resource.aws_elasticsearch_domain.pass_encrypted... pass
      # resource.aws_elasticsearch_domain.fail_not_encrypted... running
      # resource.aws_elasticsearch_domain.fail_not_encrypted... pass
      # resource.aws_elasticsearch_domain.fail_missing_config... running
      # resource.aws_elasticsearch_domain.fail_missing_config... pass
      # resource.aws_elasticsearch_domain.pass_encrypted_kms... running
      # resource.aws_elasticsearch_domain.pass_encrypted_kms... pass
      # elasticsearch-encrypted-at-rest.policytest.hcl... pass
```

---
