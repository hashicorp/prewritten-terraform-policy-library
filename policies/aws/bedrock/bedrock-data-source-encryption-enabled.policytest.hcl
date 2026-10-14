# Copyright IBM Corp. 2026

policytest {
  targets = ["bedrock-data-source-encryption-enabled.policy.hcl"]
}

# ---- PASS cases ----

resource "aws_bedrockagent_data_source" "pass_cmk_key_arn" {
  attrs = {
    name              = "pass-cmk"
    knowledge_base_id = "KB12345678"
    data_source_configuration = [{ type = "S3", s3_configuration = [{ bucket_arn = "arn:aws:s3:::docs" }] }]
    server_side_encryption_configuration = [{ kms_key_arn = "arn:aws:kms:us-east-1:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab" }]
  }
}

resource "aws_bedrockagent_data_source" "pass_customer_alias" {
  attrs = {
    name              = "pass-alias"
    knowledge_base_id = "KB12345678"
    data_source_configuration = [{ type = "S3", s3_configuration = [{ bucket_arn = "arn:aws:s3:::docs" }] }]
    server_side_encryption_configuration = [{ kms_key_arn = "arn:aws:kms:us-east-1:111122223333:alias/my-bedrock-key" }]
  }
}

# Managed knowledge base data sources are not evaluated by the control.
resource "aws_bedrockagent_data_source" "pass_managed_kb_out_of_scope" {
  attrs = {
    name              = "managed"
    knowledge_base_id = "KB12345678"
    data_source_configuration = [{ type = "MANAGED_KNOWLEDGE_BASE_CONNECTOR", managed_knowledge_base_connector_configuration = [{ connector_parameters = "{}" }] }]
  }
}

resource "aws_bedrockagent_data_source" "pass_managed_type_only_out_of_scope" {
  attrs = {
    name              = "managed-type"
    knowledge_base_id = "KB12345678"
    data_source_configuration = [{ type = "MANAGED_KNOWLEDGE_BASE_CONNECTOR" }]
  }
}

# ---- FAIL cases ----

resource "aws_bedrockagent_data_source" "fail_no_encryption_block" {
  attrs = {
    name              = "no-sse"
    knowledge_base_id = "KB12345678"
    data_source_configuration = [{ type = "S3", s3_configuration = [{ bucket_arn = "arn:aws:s3:::docs" }] }]
  }
  expect_failure = true
}

resource "aws_bedrockagent_data_source" "fail_empty_key" {
  attrs = {
    name              = "empty"
    knowledge_base_id = "KB12345678"
    server_side_encryption_configuration = [{ kms_key_arn = "" }]
  }
  expect_failure = true
}

resource "aws_bedrockagent_data_source" "fail_null_key" {
  attrs = {
    name              = "null"
    knowledge_base_id = "KB12345678"
    server_side_encryption_configuration = [{ kms_key_arn = null }]
  }
  expect_failure = true
}

resource "aws_bedrockagent_data_source" "fail_aws_managed_alias" {
  attrs = {
    name              = "aws-managed"
    knowledge_base_id = "KB12345678"
    server_side_encryption_configuration = [{ kms_key_arn = "arn:aws:kms:us-east-1:111122223333:alias/aws/bedrock" }]
  }
  expect_failure = true
}
