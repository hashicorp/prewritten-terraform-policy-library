# Lambda functions should have AWS X-Ray active tracing enabled

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Logging |

## Description

This control checks whether active tracing with AWS X-Ray is enabled for an AWS Lambda function. The control fails if active tracing with X-Ray is disabled for the Lambda function.

AWS X-Ray can provide tracing and monitoring capabilities for AWS Lambda functions, which can save time and effort debugging and operating Lambda functions. It can help you diagnose errors and identify performance bottlenecks, slowdowns, and timeouts by breaking down latency for Lambda functions. It can also help with data privacy and compliance requirements. If you enable active tracing for a Lambda function, X-Ray provides a holistic view of data flow and processing within the Lambda function, which can help you identify potential security vulnerabilities or non-compliant data handling practices. This visibility can help you maintain data integrity, confidentiality, and compliance with relevant regulations.

This rule is covered by the [lambda-function-xray-enabled](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/lambda/lambda-function-xray-enabled.policy.hcl) policy.

## Policy Results

```bash
trace:
      # lambda-function-xray-enabled.policytest.hcl... running
      # resource.aws_lambda_function.pass_tracing_mode_active... running
      # resource.aws_lambda_function.pass_tracing_mode_active... pass
      # resource.aws_lambda_function.fail_tracing_mode_passthrough... running
      # resource.aws_lambda_function.fail_tracing_mode_passthrough... pass
      # resource.aws_lambda_function.fail_tracing_config_absent... running
      # resource.aws_lambda_function.fail_tracing_config_absent... pass
      # resource.aws_lambda_function.fail_tracing_config_null... running
      # resource.aws_lambda_function.fail_tracing_config_null... pass
      # resource.aws_lambda_function.fail_tracing_config_empty... running
      # resource.aws_lambda_function.fail_tracing_config_empty... pass
      # lambda-function-xray-enabled.policytest.hcl... pass
```

---