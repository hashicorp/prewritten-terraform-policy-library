# Amazon Macie should be enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Detection services |

## Description

This control checks whether Amazon Macie is enabled for an account. The control fails if Macie isn't enabled for the account.

Amazon Macie discovers sensitive data using machine learning and pattern matching, provides visibility into data security risks, and enables automated protection against those risks. Macie automatically and continually evaluates your Amazon Simple Storage Service (Amazon S3) buckets for security and access control, and generates findings to notify you of potential issues with the security or privacy of your Amazon S3 data. Macie also automates discovery and reporting of sensitive data, such as personally identifiable information (PII), to provide you with a better understanding of the data that you store in Amazon S3. To learn more, see the Amazon Macie User Guide.

This rule is covered by the [macie-status-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/macie/macie-status-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # macie-status-check.policytest.hcl...
      running
      # resource.aws_macie2_account.pass_macie_enabled...
      running
      # resource.aws_macie2_account.pass_macie_enabled...
      pass
      # resource.aws_macie2_account.fail_macie_paused...
      running
      # resource.aws_macie2_account.fail_macie_paused...
      pass
      # resource.aws_macie2_account.fail_status_missing...
      running
      # resource.aws_macie2_account.fail_status_missing...
      pass
      # resource.aws_macie2_account.fail_invalid_status...
      running
      # resource.aws_macie2_account.fail_invalid_status...
      pass
      # macie-status-check.policytest.hcl...
      pass
```

---
