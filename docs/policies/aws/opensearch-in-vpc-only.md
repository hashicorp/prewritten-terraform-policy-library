# OpenSearch domains should not be publicly accessible

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources within VPC |

## Description

This control checks whether OpenSearch domains are in a VPC. It does not evaluate the VPC subnet routing configuration to determine public access.

You should ensure that OpenSearch domains are not attached to public subnets. See Resource-based policies in the Amazon OpenSearch Service Developer Guide. You should also ensure that your VPC is configured according to the recommended best practices. See Security best practices for your VPC in the Amazon VPC User Guide.

OpenSearch domains deployed within a VPC can communicate with VPC resources over the private AWS network, without the need to traverse the public internet. This configuration increases the security posture by limiting access to the data in transit. VPCs provide a number of network controls to secure access to OpenSearch domains, including network ACL and security groups. Security Hub recommends that you migrate public OpenSearch domains to VPCs to take advantage of these controls.

This rule is covered by the [opensearch-in-vpc-only](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/opensearch/opensearch-in-vpc-only.policy.hcl) policy.

## Policy Results

```bash
trace:
      # opensearch-in-vpc-only.policytest.hcl... running
      # resource.aws_opensearch_domain.pass_domain_with_vpc_and_subnets... running
      # resource.aws_opensearch_domain.pass_domain_with_vpc_and_subnets... pass
      # resource.aws_opensearch_domain.pass_domain_with_multiple_subnets... running
      # resource.aws_opensearch_domain.pass_domain_with_multiple_subnets... pass
      # resource.aws_opensearch_domain.fail_domain_without_vpc_options... running
      # resource.aws_opensearch_domain.fail_domain_without_vpc_options... pass
      # resource.aws_opensearch_domain.fail_domain_with_empty_subnet_ids... running
      # resource.aws_opensearch_domain.fail_domain_with_empty_subnet_ids... pass
      # resource.aws_opensearch_domain.fail_domain_with_null_vpc_options... running
      # resource.aws_opensearch_domain.fail_domain_with_null_vpc_options... pass
      # opensearch-in-vpc-only.policytest.hcl... pass
```

---
