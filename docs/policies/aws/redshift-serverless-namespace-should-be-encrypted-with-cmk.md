# Redshift Serverless namespaces should be encrypted with a customer-managed KMS key

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This control checks whether an Amazon Redshift Serverless namespace is encrypted at rest with a customer managed AWS KMS key. The control fails if the Redshift Serverless namespace isn't encrypted with a customer managed KMS key. You can optionally specify a list of KMS keys for the control to include in the evaluation.

In Amazon Redshift Serverless, a namespace defines a logical container for database objects. This control periodically checks whether the encryption settings for a namespace specify a customer managed AWS KMS key, instead of an AWS managed KMS key, for encryption of data in the namespace. With a customer managed KMS key, you have full control of the key. This includes defining and maintaining the key policy, managing grants, rotating cryptographic material, assigning tags, creating aliases, and enabling and disabling the key.

This rule is covered by the [redshift-serverless-namespace-should-be-encrypted-with-cmk](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/redshift/redshift-serverless-namespace-should-be-encrypted-with-cmk.policy.hcl) policy.

## Parameters

| Parameter | Description | Type | Default | Constraints |
| --- | --- | --- | --- | --- |
| `redshift-serverless-kmsKeyArns` | A list of Amazon Resource Names (ARNs) of AWS KMS keys to include in the evaluation. The control generates a FAILED finding if a Redshift Serverless namespace isn't encrypted with a KMS key in the list. | `string` | `""` | `{ format: csv, max_items: 3 }` |

## Policy Results

```bash
trace:
      # redshift-serverless-namespace-should-be-encrypted-with-cmk.policytest.hcl... running
      # resource.aws_redshiftserverless_namespace.pass_kms_arn... running
      # resource.aws_redshiftserverless_namespace.pass_kms_arn... pass
      # resource.aws_redshiftserverless_namespace.pass_kms_key_id_string... running
      # resource.aws_redshiftserverless_namespace.pass_kms_key_id_string... pass
      # resource.aws_redshiftserverless_namespace.fail_missing_kms... running
      # resource.aws_redshiftserverless_namespace.fail_missing_kms... pass
      # resource.aws_redshiftserverless_namespace.fail_null_kms... running
      # resource.aws_redshiftserverless_namespace.fail_null_kms... pass
      # resource.aws_redshiftserverless_namespace.fail_empty_kms... running
      # resource.aws_redshiftserverless_namespace.fail_empty_kms... pass
      # redshift-serverless-namespace-should-be-encrypted-with-cmk.policytest.hcl... pass
```

---