# Redshift Serverless namespaces should not use the default admin username

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resource configuration |

## Description

This control checks whether the admin username for an Amazon Redshift Serverless namespace is the default admin username, `admin`. The control fails if the admin username for the Redshift Serverless namespace is `admin`.

When creating an Amazon Redshift Serverless namespace, you should specify a custom admin username for the namespace. The default admin username is public knowledge. By specifying a custom admin username, you can, for example, help mitigate the risk or effectiveness of brute force attacks against the namespace.

This rule is covered by the [redshift-serverless-default-admin-check](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/redshift/redshift-serverless-default-admin-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # redshift-serverless-default-admin-check.policytest.hcl...
      running
      # resource.aws_redshiftserverless_namespace.pass_custom_username_dbadmin...
      running
      # resource.aws_redshiftserverless_namespace.pass_custom_username_dbadmin...
      pass
      # resource.aws_redshiftserverless_namespace.fail_explicit_admin_username...
      running
      # resource.aws_redshiftserverless_namespace.fail_explicit_admin_username...
      pass
      # resource.aws_redshiftserverless_namespace.fail_missing_admin_username...
      running
      # resource.aws_redshiftserverless_namespace.fail_missing_admin_username...
      pass
      # resource.aws_redshiftserverless_namespace.pass_custom_username_customadmin...
      running
      # resource.aws_redshiftserverless_namespace.pass_custom_username_customadmin...
      pass
      # resource.aws_redshiftserverless_namespace.pass_case_sensitive_Administrator...
      running
      # resource.aws_redshiftserverless_namespace.pass_case_sensitive_Administrator...
      pass
      # redshift-serverless-default-admin-check.policytest.hcl...
      pass
```

---