# Copyright IBM Corp. 2026

policytest {
  targets = ["sagemaker-endpoint-configuration-kms-key-configured.policy.hcl"]
}

# Separate file: assumes inputs.allowed_kms_arns is overridden to a non-empty
# allowlist (see testcase_gen.md 4.2 case 1 - distinct inputs {} values).
inputs {
  sagemaker-endpoint-configuration-kms-key-configured-allowed_kms_arns = [
    "arn:aws:kms:us-east-1:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab",
    "arn:aws:kms:us-east-1:123456789012:key/aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
  ]
}

# PASS: kms_key_arn is set to an ARN present in the allowlist
resource "aws_sagemaker_endpoint_configuration" "pass_kms_key_in_allowlist" {
  attrs = {
    name = "pass-kms-key-in-allowlist"
    production_variants = [
      {
        variant_name = "variant-1"
        model_name   = "test-model"
      }
    ]
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab"
  }
}

# FAIL: kms_key_arn is a valid, non-empty ARN but is NOT present in the allowlist
resource "aws_sagemaker_endpoint_configuration" "fail_kms_key_not_in_allowlist" {
  expect_failure = true
  attrs = {
    name = "fail-kms-key-not-in-allowlist"
    production_variants = [
      {
        variant_name = "variant-1"
        model_name   = "test-model"
      }
    ]
    kms_key_arn = "arn:aws:kms:us-east-1:999999999999:key/not-allowed-0000-0000-000000000000"
  }
}

# FAIL: kms_key_arn attribute is entirely omitted (missing check takes priority over allowlist)
resource "aws_sagemaker_endpoint_configuration" "fail_kms_key_missing_with_allowlist" {
  expect_failure = true
  attrs = {
    name = "fail-kms-key-missing-with-allowlist"
    production_variants = [
      {
        variant_name = "variant-1"
        model_name   = "test-model"
      }
    ]
  }
}
