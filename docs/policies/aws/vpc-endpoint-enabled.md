# VPCs should be configured with an interface endpoint for ECR API

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Access control |

## Description
## Parameters

| Parameter | Required | Description | Type | Allowed custom values | Security Hub CSPM default value |
| --------- | -------- | ----------- | ---- | --------------------- | ------------------------------- |
| serviceNames | Required | The name of the service that the control evaluates. | String | Not customizable | `ecr.api` |
| vpcIds | Optional | Comma-separated list of Amazon VPC IDs for VPC endpoints. If provided, the control fails if the services specified in the `serviceNames` parameter do not have one of these VPC endpoints. | StringList | Customize with one or more VPC IDs | No default value |
 
 
This control checks whether a virtual private cloud (VPC) that you manage has an interface VPC endpoint for Amazon ECR API. The control fails if the VPC does not have an interface VPC endpoint for ECR API. This control evaluates resources in a single account.

AWS PrivateLink enables customers to access services hosted on AWS in a highly available and scalable manner while keeping all network traffic within the AWS network. Service users can privately access services powered by PrivateLink from their VPC or their on-premises environment, without using public IPs and without requiring traffic to traverse the internet.

This rule is covered by the [vpc-endpoint-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ec2/vpc-endpoint-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # vpc-endpoint-enabled.policytest.hcl...
      running
      # resource.aws_vpc.pass_vpc_with_ecr_api_interface_endpoint...
      running
      # resource.aws_vpc.pass_vpc_with_ecr_api_interface_endpoint...
      pass
      # resource.aws_vpc.fail_vpc_without_endpoints...
      running
      # resource.aws_vpc.fail_vpc_without_endpoints...
      pass
      # resource.aws_vpc.pass_vpc_with_multiple_endpoints...
      running
      # resource.aws_vpc.pass_vpc_with_multiple_endpoints...
      pass
      # vpc-endpoint-enabled.policytest.hcl...
      pass
```

---