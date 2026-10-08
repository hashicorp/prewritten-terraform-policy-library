# Lambda functions should be in a VPC

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources within VPC |

## Description

This control checks whether a Lambda function is deployed in a virtual private cloud (VPC). The control fails if the Lambda function isn't deployed in a VPC. Security Hub CSPM doesn't evaluate the VPC subnet routing configuration to determine public reachability. You might see failed findings for Lambda@Edge resources.

Deploying resources in a VPC strengthens security and control over network configurations. Such deployments also offer scalability and high fault tolerance across multiple Availability Zones. You can customize VPC deployments to meet diverse application requirements.

This rule is covered by the [lambda-functions-should-be-in-a-vpc](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/lambda/lambda-functions-should-be-in-a-vpc.policy.hcl) policy.

## Policy Results

```bash
trace:
      # lambda-functions-should-be-in-a-vpc.policytest.hcl... running
      # resource.aws_lambda_function.pass_valid_vpc_config... running
      # resource.aws_lambda_function.pass_valid_vpc_config... pass
      # resource.aws_lambda_function.fail_no_vpc_config... running
      # resource.aws_lambda_function.fail_no_vpc_config... pass
      # resource.aws_lambda_function.fail_null_vpc_config... running
      # resource.aws_lambda_function.fail_null_vpc_config... pass
      # resource.aws_lambda_function.fail_empty_vpc_config_list... running
      # resource.aws_lambda_function.fail_empty_vpc_config_list... pass
      # resource.aws_lambda_function.fail_empty_subnet_ids... running
      # resource.aws_lambda_function.fail_empty_subnet_ids... pass
      # resource.aws_lambda_function.fail_empty_security_group_ids... running
      # resource.aws_lambda_function.fail_empty_security_group_ids... pass
      # resource.aws_lambda_function.fail_null_security_group_ids... running
      # resource.aws_lambda_function.fail_null_security_group_ids... pass
      # resource.aws_lambda_function.fail_both_empty... running
      # resource.aws_lambda_function.fail_both_empty... pass
      # lambda-functions-should-be-in-a-vpc.policytest.hcl... pass
```

---