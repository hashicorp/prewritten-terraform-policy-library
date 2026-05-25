# SSM documents should not be public

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources not publicly accessible |

## Description

This control checks whether AWS Systems Manager documents that are owned by an account are public. The control fails if Systems Manager documents that have Self as the owner are public.

Systems Manager documents that are public might allow unintended access to your documents. A public Systems Manager document can expose valuable information about your account, resources, and internal processes.

Unless your use case requires public sharing, we recommend that you block public sharing for Systems Manager documents that have Self as the owner.

This rule is covered by the [ssm-document-not-public](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/ssm/ssm-document-not-public.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ssm-document-not-public.policytest.hcl...
      running
      # resource.aws_ssm_document.pass_no_permissions...
      running
      # resource.aws_ssm_document.pass_no_permissions...
      pass
      # resource.aws_ssm_document.pass_specific_accounts...
      running
      # resource.aws_ssm_document.pass_specific_accounts...
      pass
      # resource.aws_ssm_document.fail_public_document...
      running
      # resource.aws_ssm_document.fail_public_document...
      pass
      # resource.aws_ssm_document.pass_not_self_owned...
      running
      # resource.aws_ssm_document.pass_not_self_owned...
      pass
      # resource.aws_ssm_document.pass_empty_account_ids...
      running
      # resource.aws_ssm_document.pass_empty_account_ids...
      pass
      # resource.aws_ssm_document.fail_all_with_specific...
      running
      # resource.aws_ssm_document.fail_all_with_specific...
      pass
      # ssm-document-not-public.policytest.hcl...
      pass
```

---