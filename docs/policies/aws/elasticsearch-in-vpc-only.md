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
      # resource.aws_elasticsearch_domain.compliant_single... running
      # resource.aws_elasticsearch_domain.compliant_single... pass
      # resource.aws_elasticsearch_domain.compliant_multi... running
      # resource.aws_elasticsearch_domain.compliant_multi... pass
      # resource.aws_elasticsearch_domain.non_compliant_no_vpc... running
      # resource.aws_elasticsearch_domain.non_compliant_no_vpc... pass
      # resource.aws_elasticsearch_domain.non_compliant_empty_subnets... running
      # resource.aws_elasticsearch_domain.non_compliant_empty_subnets... pass
      # elasticsearch-in-vpc-only.policytest.hcl... pass
```

---
