# CloudWatch log groups should be encrypted with AWS KMS keys

| Provider | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-at-rest |

## Description

This policy checks if Amazon CloudWatch Log Groups are encrypted with any AWS KMS key or a specified AWS KMS key Id. The policy fails if a CloudWatch Log Group is not encrypted with a KMS key or is encrypted with a KMS key not supplied in the rule parameter.

The policy evaluates `aws_cloudwatch_log_group` resources.

This rule is covered by the [cloudwatch-log-group-kms-encryption](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cloudwatch/cloudwatch-log-group-kms-encryption.policy.hcl) policy.

## Policy Results

```bash
trace:
      #
      cloudwatch-log-group-kms-encryption.policytest.hcl...
      running
      # resource.aws_cloudwatch_log_group.pass_any_kms_key...
      running
      # resource.aws_cloudwatch_log_group.pass_any_kms_key...
      pass
      #
      resource.aws_cloudwatch_log_group.fail_kms_key_id_missing...
      running
      #
      resource.aws_cloudwatch_log_group.fail_kms_key_id_missing...
      pass
      #
      resource.aws_cloudwatch_log_group.fail_kms_key_id_null...
      running
      #
      resource.aws_cloudwatch_log_group.fail_kms_key_id_null...
      pass
      #
      resource.aws_cloudwatch_log_group.fail_kms_key_id_empty_string...
      running
      #
      resource.aws_cloudwatch_log_group.fail_kms_key_id_empty_string...
      pass
      #
      resource.aws_cloudwatch_log_group.pass_matching_required_key_f2...
      running
      #
      resource.aws_cloudwatch_log_group.pass_matching_required_key_f2...
      pass
      #
      resource.aws_cloudwatch_log_group.fail_missing_key_with_required_f2...
      running
      #
      resource.aws_cloudwatch_log_group.fail_missing_key_with_required_f2...
      pass
      #
      cloudwatch-log-group-kms-encryption.policytest.hcl...
      pass
```

---
