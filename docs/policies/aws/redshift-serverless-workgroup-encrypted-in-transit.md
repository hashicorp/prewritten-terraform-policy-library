# Connections to Redshift Serverless workgroups should be required to use SSL

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Encryption of data-in-transit |

## Description

This control checks whether connections to an Amazon Redshift Serverless workgroup are required to encrypt data in transit. The control fails if the `require_ssl` configuration parameter for the workgroup is set to false.

An Amazon Redshift Serverless workgroup is a collection of compute resources that groups together compute resources like RPUs, VPC subnet groups, and security groups. Properties of a workgroup include network and security settings. These settings specify whether connections to a workgroup should be required to use SSL to encrypt data in transit.

This rule is covered by the [redshift-serverless-workgroup-encrypted-in-transit](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/redshift/redshift-serverless-workgroup-encrypted-in-transit.policy.hcl) policy.

## Policy Results

```bash
trace:
      # redshift-serverless-workgroup-encrypted-in-transit.policytest.hcl...
      running
      # resource.aws_redshiftserverless_workgroup.pass_ssl_enabled...
      running
      # resource.aws_redshiftserverless_workgroup.pass_ssl_enabled...
      pass
      # resource.aws_redshiftserverless_workgroup.fail_ssl_disabled...
      running
      # resource.aws_redshiftserverless_workgroup.fail_ssl_disabled...
      pass
      # resource.aws_redshiftserverless_workgroup.fail_no_config_parameter...
      running
      # resource.aws_redshiftserverless_workgroup.fail_no_config_parameter...
      pass
      # resource.aws_redshiftserverless_workgroup.fail_missing_require_ssl...
      running
      # resource.aws_redshiftserverless_workgroup.fail_missing_require_ssl...
      pass
      # resource.aws_redshiftserverless_workgroup.pass_multiple_config_params...
      running
      # resource.aws_redshiftserverless_workgroup.pass_multiple_config_params...
      pass
      # redshift-serverless-workgroup-encrypted-in-transit.policytest.hcl...
      pass
```

---