# Copyright IBM Corp. 2026

# Bedrock AgentCore custom code interpreters should use a private network configuration

policy {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.67.0, < 7.0.0"
    }
  }
}

input "bedrockagentcore-codeinterpreter-networkmode-check-enforcement-level" {
  type    = string
  default = "advisory"
}

resource_policy "aws_bedrockagentcore_code_interpreter" "private_network_mode" {
  enforcement_level = input.bedrockagentcore-codeinterpreter-networkmode-check-enforcement-level

  locals {
    mode_raw = core::try(attrs.network_configuration[0].network_mode, null)
    mode     = local.mode_raw == null ? "" : core::upper(core::trimspace(local.mode_raw))
  }

  # PUBLIC and SANDBOX are not private; an omitted network_configuration is not private either.
  enforce {
    condition     = local.mode == "VPC"
    error_message = "Bedrock AgentCore custom code interpreters must use a private network configuration. Set 'network_configuration.network_mode' to \"VPC\" (PUBLIC and SANDBOX are not allowed)."
  }
}
