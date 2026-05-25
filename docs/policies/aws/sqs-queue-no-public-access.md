# SQS queue access policies should not allow public access

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resource not publicly accessible |

## Description

This controls checks whether an Amazon SQS access policy allows public access to an SQS queue. The control fails if an SQS access policy allows public access to the queue.

An Amazon SQS access policy can allow public access to an SQS queue, which might allow an anonymous user or any authenticated AWS IAM identity to access the queue. SQS access policies typically provide this access by specifying the wildcard character (*) in the Principal element of the policy, not using proper conditions to restrict access to the queue, or both. If an SQS access policy allows public access, third parties might be able to perform tasks such as receive messages from the queue, send messages to the queue, or modify the access policy for the queue. This could result in events such as data exfiltration, a denial of service, or injection of messages into the queue by a threat actor.

This rule is covered by the [sqs-queue-no-public-access](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/sqs/sqs-queue-no-public-access.policy.hcl) policy.

## Policy Results

```bash
trace:
      # sqs-queue-no-public-access.policytest.hcl...
      running
      # resource.aws_sqs_queue_policy.pass_specific_account_principal...
      running
      # resource.aws_sqs_queue_policy.pass_specific_account_principal...
      pass
      # resource.aws_sqs_queue_policy.fail_wildcard_principal...
      running
      # resource.aws_sqs_queue_policy.fail_wildcard_principal...
      pass
      # resource.aws_sqs_queue_policy.fail_wildcard_principal_aws...
      running
      # resource.aws_sqs_queue_policy.fail_wildcard_principal_aws...
      pass
      # resource.aws_sqs_queue.fail_inline_wildcard_principal...
      running
      # resource.aws_sqs_queue.fail_inline_wildcard_principal...
      pass
      # resource.aws_sqs_queue.pass_inline_specific_principal...
      running
      # resource.aws_sqs_queue.pass_inline_specific_principal...
      pass
      # resource.aws_sqs_queue.no_policy...
      running
      # resource.aws_sqs_queue.no_policy...
      pass
      # sqs-queue-no-public-access.policytest.hcl...
      pass
```

---