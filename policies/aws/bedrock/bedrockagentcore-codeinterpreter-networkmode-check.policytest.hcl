# Copyright IBM Corp. 2026

policytest {
  targets = ["bedrockagentcore-codeinterpreter-networkmode-check.policy.hcl"]
}

# ---- PASS cases ----

resource "aws_bedrockagentcore_code_interpreter" "pass_vpc_mode" {
  attrs = {
    name = "pass_vpc"
    network_configuration = [{
      network_mode = "VPC"
      vpc_config   = [{ security_groups = ["sg-0123456789abcdef0"], subnets = ["subnet-0123456789abcdef0"] }]
    }]
  }
}

resource "aws_bedrockagent_data_source" "pass_unrelated_resource" {
  attrs = {
    name              = "unrelated"
    knowledge_base_id = "KB12345678"
  }
}

# ---- FAIL cases ----

resource "aws_bedrockagentcore_code_interpreter" "fail_public_mode" {
  attrs = {
    name                  = "fail_public"
    network_configuration = [{ network_mode = "PUBLIC" }]
  }
  expect_failure = true
}

resource "aws_bedrockagentcore_code_interpreter" "fail_sandbox_mode" {
  attrs = {
    name                  = "fail_sandbox"
    network_configuration = [{ network_mode = "SANDBOX" }]
  }
  expect_failure = true
}

resource "aws_bedrockagentcore_code_interpreter" "fail_no_network_configuration" {
  attrs = {
    name = "fail_missing"
  }
  expect_failure = true
}
