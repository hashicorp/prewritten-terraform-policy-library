# Cognito user pools should have threat protection activated with full function enforcement mode for custom authentication

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Secure access management |

## Description

This control checks whether an Amazon Cognito user pool has threat protection activated with the enforcement mode set to full function for custom authentication. The control fails if the user pool has threat protection disabled or if the enforcement mode isn't set to full function for custom authentication.

Threat protection, formerly called advanced security features, is a set of monitoring tools for unwanted activity in your user pool, and configuration tools to automatically shut down potentially malicious activity. After you create an Amazon Cognito user pool, you can activate threat protection with full function enforcement mode for custom authentication and customize the actions that are taken in response to different risks. Full-function mode includes a set of automatic reactions to detect unwanted activity and compromised passwords.

This rule is covered by the [cognito-userpool-cust-auth-threat-full-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/cognito/cognito-userpool-cust-auth-threat-full-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # cognito-userpool-cust-auth-threat-full-check.policytest.hcl...
      running
      # resource.aws_cognito_user_pool.compliant_pool...
      running
      # resource.aws_cognito_user_pool.compliant_pool...
      pass
      # resource.aws_cognito_user_pool.no_add_ons...
      running
      # resource.aws_cognito_user_pool.no_add_ons...
      pass
      # resource.aws_cognito_user_pool.audit_mode...
      running
      # resource.aws_cognito_user_pool.audit_mode...
      pass
      # resource.aws_cognito_user_pool.off_mode...
      running
      # resource.aws_cognito_user_pool.off_mode...
      pass
      # resource.aws_cognito_user_pool.no_additional_flows...
      running
      # resource.aws_cognito_user_pool.no_additional_flows...
      pass
      # resource.aws_cognito_user_pool.custom_auth_audit...
      running
      # resource.aws_cognito_user_pool.custom_auth_audit...
      pass
      # cognito-userpool-cust-auth-threat-full-check.policytest.hcl...
      pass
```

---
