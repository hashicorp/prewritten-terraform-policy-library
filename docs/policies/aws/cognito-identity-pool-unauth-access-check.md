# Cognito identity pools should not allow unauthenticated identities

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Passwordless authentication |

## Description

This control checks whether an Amazon Cognito identity pool is configured to allow unauthenticated identities. The control fails if guest access is activated (`AllowUnauthenticatedIdentities` is set to `true`) for the identity pool.

If an Amazon Cognito identity pool allows unauthenticated identities, the identity pool provides temporary AWS credentials to users who haven't authenticated through an identity provider (guests). This creates security risks because it allows anonymous access to AWS resources. If you deactivate guest access, you can help ensure that only properly authenticated users can access your AWS resources, which reduces the risk of unauthorized access and potential security breaches. As a best practice, an identity pool should require authentication through supported identity providers. If unauthenticated access is necessary, it's important to carefully restrict permissions for unauthenticated identities, and regularly review and monitor their usage.

This rule is covered by the [cognito-identity-pool-unauth-access-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cognito/cognito-identity-pool-unauth-access-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cognito-identity-pool-unauth-access-check.policytest.hcl...
      running
      # resource.aws_cognito_identity_pool.pass_unauthenticated_disabled...
      running
      # resource.aws_cognito_identity_pool.pass_unauthenticated_disabled...
      pass
      # resource.aws_cognito_identity_pool.fail_unauthenticated_enabled...
      running
      # resource.aws_cognito_identity_pool.fail_unauthenticated_enabled...
      pass
      # resource.aws_cognito_identity_pool.fail_attribute_missing...
      running
      # resource.aws_cognito_identity_pool.fail_attribute_missing...
      pass
      # cognito-identity-pool-unauth-access-check.policytest.hcl...
      pass
```

---
