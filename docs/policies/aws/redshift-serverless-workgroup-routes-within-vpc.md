# Amazon Redshift Serverless workgroups should use enhanced VPC routing

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources within VPC |

## Description

This control checks whether enhanced VPC routing is enabled for an Amazon Redshift Serverless workgroup. The control fails if enhanced VPC routing is disabled for the workgroup.

If enhanced VPC routing is disabled for an Amazon Redshift Serverless workgroup, Amazon Redshift routes traffic through the internet, including traffic to other services within the AWS network. If you enable enhanced VPC routing for a workgroup, Amazon Redshift forces all COPY and UNLOAD traffic between your cluster and your data repositories through your virtual private cloud (VPC) based on the Amazon VPC service. With enhanced VPC routing, you can use standard VPC features to control the flow of data between your Amazon Redshift cluster and other resources. This includes features such as VPC security groups and endpoint policies, network access control lists (ACLs), and Domain Name System (DNS) servers. You can also use VPC flow logs to monitor COPY and UNLOAD traffic.

This rule is covered by the [redshift-serverless-workgroup-routes-within-vpc](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/redshift/redshift-serverless-workgroup-routes-within-vpc.policy.hcl) policy.

## Policy Results

```bash
trace:
      # redshift-serverless-workgroup-routes-within-vpc.policytest.hcl...
      running
      # resource.aws_redshiftserverless_workgroup.compliant...
      running
      # resource.aws_redshiftserverless_workgroup.compliant...
      pass
      # resource.aws_redshiftserverless_workgroup.non_compliant...
      running
      # resource.aws_redshiftserverless_workgroup.non_compliant...
      pass
      # resource.aws_redshiftserverless_workgroup.missing_attribute...
      running
      # resource.aws_redshiftserverless_workgroup.missing_attribute...
      pass
      # redshift-serverless-workgroup-routes-within-vpc.policytest.hcl...
      pass
```

---