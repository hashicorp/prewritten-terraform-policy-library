# VPCs should be configured with an interface endpoint for Systems Manager Incident Manager Contacts

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Access control |

## Description

## Parameters

| Parameter | Required | Description | Type | Allowed custom values | Security Hub CSPM default value |
| --------- | -------- | ----------- | ---- | --------------------- | ------------------------------- |
| serviceNames | Required | The name of the service that the control evaluates. | String | Not customizable | `ssm-contacts` |
| vpcIds | Optional | Comma-separated list of Amazon VPC IDs for VPC endpoints. If provided, the control fails if the services specified in the `serviceNames` parameter do not have one of these VPC endpoints. | StringList | Customize with one or more VPC IDs | No default value | 


This control checks whether a virtual private cloud (VPC) that you manage has an interface VPC endpoint for AWS Systems Manager Incident Manager Contacts. The control fails if the VPC does not have an interface VPC endpoint for Systems Manager Incident Manager Contacts. This control evaluates resources in a single account.

AWS PrivateLink enables customers to access services hosted on AWS in a highly available and scalable manner while keeping all network traffic within the AWS network. Service users can privately access services powered by PrivateLink from their VPC or their on-premises environment, without using public IPs and without requiring traffic to traverse the internet.

This rule is covered by the [ec2-vpc-ssm-contacts-endpoint](https://github.com/hashicorp/policy-library-for-tfpolicy/blob/main/policies/ec2/ec2-vpc-ssm-contacts-endpoint.policy.hcl) policy.

## Policy Results

```bash
trace:
      # ec2-vpc-ssm-contacts-endpoint.policytest.hcl...
      running
      # resource.aws_vpc.compliant...
      running
      # resource.aws_vpc.compliant...
      pass
      # resource.aws_vpc.non_compliant...
      running
      # resource.aws_vpc.non_compliant...
      pass
      # ec2-vpc-ssm-contacts-endpoint.policytest.hcl...
      pass
```

---