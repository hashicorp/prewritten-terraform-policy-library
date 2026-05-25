# Redshift Serverless workgroups should prohibit public access

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources not publicly accessible |

## Description

This control checks whether public access is disabled for an Amazon Redshift Serverless workgroup. It evaluates the `publiclyAccessible` property of a Redshift Serverless workgroup. The control fails if public access is enabled (`true`) for the workgroup.

The public access (`publiclyAccessible`) setting for an Amazon Redshift Serverless workgroup specifies whether the workgroup can be accessed from a public network. If public access is enabled (`true`) for a workgroup, Amazon Redshift creates an Elastic IP address that makes the workgroup publicly accessible from outside the VPC. If you don't want a workgroup to be publicly accessible, disable public access for it.

This rule is covered by the [redshift-serverless-workgroup-no-public-access](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/redshift/redshift-serverless-workgroup-no-public-access.policy.hcl) policy.

## Policy Results

```bash
trace:
      # redshift-serverless-workgroup-no-public-access.policytest.hcl...
      running
      # resource.aws_redshiftserverless_workgroup.compliant...
      running
      # resource.aws_redshiftserverless_workgroup.compliant...
      pass
      # resource.aws_redshiftserverless_workgroup.default_secure...
      running
      # resource.aws_redshiftserverless_workgroup.default_secure...
      pass
      # resource.aws_redshiftserverless_workgroup.non_compliant...
      running
      # resource.aws_redshiftserverless_workgroup.non_compliant...
      pass
      # redshift-serverless-workgroup-no-public-access.policytest.hcl...
      pass
```

---