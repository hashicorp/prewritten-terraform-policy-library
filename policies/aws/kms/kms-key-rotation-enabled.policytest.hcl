# Copyright IBM Corp. 2026

policytest {
  targets = ["kms-key-rotation-enabled.policy.hcl"]
}

resource "aws_kms_key" "pass_symmetric_rotation_enabled" {
  attrs = {
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    enable_key_rotation      = true
  }
}

resource "aws_kms_key" "pass_omitted_key_spec_rotation_enabled" {
  attrs = {
    enable_key_rotation = true
  }
}

resource "aws_kms_key" "pass_null_key_spec_rotation_enabled" {
  attrs = {
    customer_master_key_spec = null
    enable_key_rotation      = true
  }
}

resource "aws_kms_key" "pass_empty_key_spec_rotation_enabled" {
  attrs = {
    customer_master_key_spec = ""
    enable_key_rotation      = true
  }
}

resource "aws_kms_key" "fail_symmetric_rotation_disabled" {
  expect_failure = true
  attrs = {
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    enable_key_rotation      = false
  }
}

resource "aws_kms_key" "fail_symmetric_rotation_omitted" {
  expect_failure = true
  attrs = {
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
  }
}

resource "aws_kms_key" "fail_symmetric_rotation_null" {
  expect_failure = true
  attrs = {
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    enable_key_rotation      = null
  }
}

resource "aws_kms_key" "pass_asymmetric_key_excluded" {
  attrs = {
    customer_master_key_spec = "RSA_3072"
    enable_key_rotation      = false
  }
}
