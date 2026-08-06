# OpenSearch domains should have encryption at rest enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether OpenSearch domains have encryption-at-rest configuration enabled. The check fails if encryption at rest is not enabled.

For an added layer of security for sensitive data, you should configure your OpenSearch Service domain to be encrypted at rest. When you configure encryption of data at rest, AWS KMS stores and manages your encryption keys. To perform the encryption, AWS KMS uses the Advanced Encryption Standard algorithm with 256-bit keys (AES-256).

To learn more about OpenSearch Service encryption at rest, see Encryption of data at rest for Amazon OpenSearch Service in the Amazon OpenSearch Service Developer Guide.

This rule is covered by the [opensearch-encrypted-at-rest](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/opensearch/opensearch-encrypted-at-rest.policy.hcl) policy.

## Policy Results

```bash
trace:
      # opensearch-encrypted-at-rest.policytest.hcl... running
      # resource.aws_opensearch_domain.pass_encrypted... running
      # resource.aws_opensearch_domain.pass_encrypted... pass
      # resource.aws_opensearch_domain.fail_not_encrypted... running
      # resource.aws_opensearch_domain.fail_not_encrypted... pass
      # resource.aws_opensearch_domain.fail_no_config... running
      # resource.aws_opensearch_domain.fail_no_config... pass
      # resource.aws_opensearch_domain.fail_invalid_version... running
      # resource.aws_opensearch_domain.fail_invalid_version... pass
      # resource.aws_opensearch_domain.fail_opensearch_not_encrypted... running
      # resource.aws_opensearch_domain.fail_opensearch_not_encrypted... pass
      # resource.aws_opensearch_domain.pass_opensearch_encrypted... running
      # resource.aws_opensearch_domain.pass_opensearch_encrypted... pass
      # opensearch-encrypted-at-rest.policytest.hcl... pass
```

---
