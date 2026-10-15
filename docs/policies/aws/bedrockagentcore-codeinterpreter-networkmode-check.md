# Bedrock AgentCore custom code interpreters should use a private network configuration

| Provider            | Category |
| ------------------- | -------- |
| Amazon Web Services | Resources within VPC |

## Description

This control checks whether an Amazon Bedrock AgentCore custom code interpreter is configured with a private network mode. The control fails if the network mode is set to `PUBLIC` or `SANDBOX`. Configuring custom code interpreters with a private network mode keeps code execution environments isolated within your VPC.

The policy evaluates each `aws_bedrockagentcore_code_interpreter` resource and passes only when `network_configuration.network_mode` is `VPC`. Any other value, including `PUBLIC` and `SANDBOX`, and an omitted `network_configuration` is non-compliant.

This rule is covered by the [bedrockagentcore-codeinterpreter-networkmode-check](https://github.com/hashicorp/prewritten-terraform-policy-library/blob/main/policies/aws/bedrock/bedrockagentcore-codeinterpreter-networkmode-check.policy.hcl) policy.

## Policy Results

```bash
trace:
      # bedrockagentcore-codeinterpreter-networkmode-check.policytest.hcl...
      running
      # resource.aws_bedrockagentcore_code_interpreter.pass_vpc_mode...
      running
      # resource.aws_bedrockagentcore_code_interpreter.pass_vpc_mode...
      pass
      # resource.aws_bedrockagent_data_source.pass_unrelated_resource...
      running
      # resource.aws_bedrockagent_data_source.pass_unrelated_resource...
      pass
      # resource.aws_bedrockagentcore_code_interpreter.fail_public_mode...
      running
      # resource.aws_bedrockagentcore_code_interpreter.fail_public_mode...
      pass
      # resource.aws_bedrockagentcore_code_interpreter.fail_sandbox_mode...
      running
      # resource.aws_bedrockagentcore_code_interpreter.fail_sandbox_mode...
      pass
      # resource.aws_bedrockagentcore_code_interpreter.fail_no_network_configuration...
      running
      # resource.aws_bedrockagentcore_code_interpreter.fail_no_network_configuration...
      pass
      # bedrockagentcore-codeinterpreter-networkmode-check.policytest.hcl...
      pass
```

---
