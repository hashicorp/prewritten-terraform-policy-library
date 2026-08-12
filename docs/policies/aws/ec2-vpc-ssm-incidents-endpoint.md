# VPCs should be configured with an interface endpoint for Systems Manager Incident Manager

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Access control |


## Description

## Parameters

| Parameter | Required | Description | Type | Allowed custom values | Security Hub CSPM default value |
| --------- | -------- | ----------- | ---- | --------------------- | ------------------------------- |
| serviceNames | Required | The name of the service that the control evaluates. | String | Not customizable | `ssm-incidents` |
| vpcIds | Optional | Comma-separated list of Amazon VPC IDs for VPC endpoints. If provided, the control fails if the services specified in the `serviceNames` parameter do not have one of these VPC endpoints. | StringList | Customize with one or more VPC IDs | No default value |
 

This control checks whether a virtual private cloud (VPC) that you manage has an interface VPC endpoint for AWS Systems Manager Incident Manager. The control fails if the VPC does not have an interface VPC endpoint for Systems Manager Incident Manager. This control evaluates resources in a single account.

AWS PrivateLink enables customers to access services hosted on AWS in a highly available and scalable manner while keeping all network traffic within the AWS network. Service users can privately access services powered by PrivateLink from their VPC or their on-premises environment, without using public IPs and without requiring traffic to traverse the internet.

This rule is covered by the [ec2-vpc-ssm-incidents-endpoint](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/ec2/ec2-vpc-ssm-incidents-endpoint.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ec2-vpc-ssm-incidents-endpoint.policytest.hcl...
      running
      # resource.aws_vpc_endpoint.pass_endpoint_us_east_1...
      running
      # resource.aws_vpc_endpoint.pass_endpoint_us_east_1...
      pass
      # resource.aws_vpc_endpoint.fail_endpoint_invalid_service...
      running
      # resource.aws_vpc_endpoint.fail_endpoint_invalid_service...
      pass
      # ec2-vpc-ssm-incidents-endpoint.policytest.hcl...
      pass
```

---