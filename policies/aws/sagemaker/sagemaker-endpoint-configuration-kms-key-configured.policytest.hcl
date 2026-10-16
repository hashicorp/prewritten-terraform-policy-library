# Copyright IBM Corp. 2026

policytest {
  targets = ["sagemaker-endpoint-configuration-kms-key-configured.policy.hcl"]
}

# PASS: kms key set
resource "aws_sagemaker_endpoint_configuration" "pass_kms_key_set" {
  attrs = {
    name = "pass-kms-key-set"
    production_variants = [
      {
        variant_name = "variant-1"
        model_name   = "test-model"
      }
    ]
    kms_key_arn = "arn:aws:kms:us-east-1:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab"
  }
}

# FAIL: kms_key_arn attribute is entirely omitted
resource "aws_sagemaker_endpoint_configuration" "fail_kms_key_missing" {
  expect_failure = true
  attrs = {
    name = "fail-kms-key-missing"
    production_variants = [
      {
        variant_name = "variant-1"
        model_name   = "test-model"
      }
    ]
  }
}

# FAIL: kms_key_arn is explicitly set to an empty string
resource "aws_sagemaker_endpoint_configuration" "fail_kms_key_empty" {
  expect_failure = true
  attrs = {
    name = "fail-kms-key-empty"
    production_variants = [
      {
        variant_name = "variant-1"
        model_name   = "test-model"
      }
    ]
    kms_key_arn = ""
  }
}

# FAIL: kms_key_arn is explicitly set to null (treated the same as missing/empty)
resource "aws_sagemaker_endpoint_configuration" "fail_kms_key_null" {
  expect_failure = true
  attrs = {
    name = "fail-kms-key-null"
    production_variants = [
      {
        variant_name = "variant-1"
        model_name   = "test-model"
      }
    ]
    kms_key_arn = null
  }
}

# PASS: kms key in allowlist
resource "aws_sagemaker_endpoint_configuration" "pass_kms_key_in_allowlist_f2" {
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

# FAIL: kms_key_arn attribute is entirely omitted (missing check takes priority over allowlist)
resource "aws_sagemaker_endpoint_configuration" "fail_kms_key_missing_with_allowlist_f2" {
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
