# Custom EventBridge schema registries should have a resource policy attached

| Provider | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This policy checks if custom Amazon EventBridge schema registries have a resource policy attached. The policy fails for custom schema registries without a resource policy attached.

The policy evaluates `aws_schemas_registry` resources.

This rule is covered by the [eventbridge-schema-registry-policy-attached](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/eventbridge/eventbridge-schema-registry-policy-attached.policy.hcl) policy.

## Policy Results

```bash
trace:
      #
      eventbridge-schema-registry-policy-attached.policytest.hcl...
      running
      # resource.aws_schemas_registry.pass_with_policy...
      running
      # resource.aws_schemas_registry.pass_with_policy...
      pass
      # resource.aws_schemas_registry.fail_no_policy...
      running
      # resource.aws_schemas_registry.fail_no_policy...
      pass
      # resource.aws_schemas_registry.fail_mismatched_name...
      running
      # resource.aws_schemas_registry.fail_mismatched_name...
      pass
      # resource.aws_schemas_registry.fail_empty_policy...
      running
      # resource.aws_schemas_registry.fail_empty_policy...
      pass
      # resource.aws_schemas_registry.pass_multiple_policies...
      running
      # resource.aws_schemas_registry.pass_multiple_policies...
      pass
      # resource.aws_schemas_registry.fail_missing_name...
      running
      # resource.aws_schemas_registry.fail_missing_name...
      pass
      # resource.aws_schemas_registry.fail_null_name...
      running
      # resource.aws_schemas_registry.fail_null_name...
      pass
      #
      eventbridge-schema-registry-policy-attached.policytest.hcl...
      pass
```

---
