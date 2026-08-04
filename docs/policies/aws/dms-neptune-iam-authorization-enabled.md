# DMS endpoints for Neptune databases should have IAM authorization enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Passwordless authentication |

## Description

This control checks whether an AWS DMS endpoint for an Amazon Neptune database is configured with IAM authorization. The control fails if the DMS endpoint doesn't have IAM authorization enabled.

AWS Identity and Access Management (IAM) provides fine-grained access control across AWS. With IAM, you can specify who can access which services and resources, and under which conditions. With IAM policies, you manage permissions to your workforce and systems to ensure least-privilege permissions. By enabling IAM authorization on AWS DMS endpoints for Neptune databases, you can grant authorization privileges to IAM users by using a service role specified by the ServiceAccessRoleARN parameter.

This rule is covered by the [dms-neptune-iam-authorization-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/dms/dms-neptune-iam-authorization-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # dms-neptune-iam-authorization-enabled.policytest.hcl...
      running
      # resource.aws_dms_endpoint.neptune_compliant...
      running
      # resource.aws_dms_endpoint.neptune_compliant...
      pass
      # resource.aws_dms_endpoint.neptune_no_iam...
      running
      # resource.aws_dms_endpoint.neptune_no_iam...
      pass
      # resource.aws_dms_endpoint.neptune_empty_role...
      running
      # resource.aws_dms_endpoint.neptune_empty_role...
      pass
      # resource.aws_dms_endpoint.neptune_any_role...
      running
      # resource.aws_dms_endpoint.neptune_any_role...
      pass
      # resource.aws_dms_endpoint.mysql_endpoint...
      running
      # resource.aws_dms_endpoint.mysql_endpoint...
      pass
      # resource.aws_dms_endpoint.neptune_long_arn...
      running
      # resource.aws_dms_endpoint.neptune_long_arn...
      pass
      # dms-neptune-iam-authorization-enabled.policytest.hcl...
      pass
```

---
