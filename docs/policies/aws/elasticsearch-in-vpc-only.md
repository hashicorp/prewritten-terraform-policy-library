# Elasticsearch domains should not be publicly accessible

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources within VPC |

## Description

This control checks whether Elasticsearch domains are in a VPC. It does not evaluate the VPC subnet routing configuration to determine public access. You should ensure that Elasticsearch domains are not attached to public subnets. See Resource-based policies in the Amazon OpenSearch Service Developer Guide. You should also ensure that your VPC is configured according to the recommended best practices. See Security best practices for your VPC in the Amazon VPC User Guide.

Elasticsearch domains deployed within a VPC can communicate with VPC resources over the private AWS network, without the need to traverse the public internet. This configuration increases the security posture by limiting access to the data in transit. VPCs provide a number of network controls to secure access to Elasticsearch domains, including network ACL and security groups. Security Hub CSPM recommends that you migrate public Elasticsearch domains to VPCs to take advantage of these controls.

This rule is covered by the [elasticsearch-in-vpc-only](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/elasticsearch/elasticsearch-in-vpc-only.policy.hcl) policy.

## Policy Results

```bash
trace:
      # elasticsearch-in-vpc-only.policytest.hcl... running
      # resource.aws_elasticsearch_domain.pass_with_vpc_single_subnet... running
      # resource.aws_elasticsearch_domain.pass_with_vpc_single_subnet... pass
      # resource.aws_elasticsearch_domain.pass_with_vpc_multiple_subnets... running
      # resource.aws_elasticsearch_domain.pass_with_vpc_multiple_subnets... pass
      # resource.aws_elasticsearch_domain.fail_no_vpc_options... running
      # resource.aws_elasticsearch_domain.fail_no_vpc_options... pass
      # resource.aws_elasticsearch_domain.fail_empty_subnet_ids... running
      # resource.aws_elasticsearch_domain.fail_empty_subnet_ids... pass
      # resource.aws_elasticsearch_domain.fail_subnet_ids_null... running
      # resource.aws_elasticsearch_domain.fail_subnet_ids_null... pass
      # resource.aws_elasticsearch_domain.fail_vpc_options_null... running
      # resource.aws_elasticsearch_domain.fail_vpc_options_null... pass
      # resource.aws_elasticsearch_domain.fail_vpc_options_omitted... running
      # resource.aws_elasticsearch_domain.fail_vpc_options_omitted... pass
      # elasticsearch-in-vpc-only.policytest.hcl... pass
```

---
