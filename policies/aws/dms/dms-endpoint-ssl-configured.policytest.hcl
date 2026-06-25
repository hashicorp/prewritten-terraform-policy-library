# Copyright IBM Corp. 2026

policytest {
  targets = ["dms-endpoint-ssl-configured.policy.hcl"]
}

# PASS: ssl_mode = "require"
resource "aws_dms_endpoint" "pass_ssl_require" {
  attrs = {
    endpoint_id   = "pass-require"
    endpoint_type = "source"
    engine_name   = "mysql"
    ssl_mode      = "require"
  }
}

# PASS: ssl_mode = "verify-ca"
resource "aws_dms_endpoint" "pass_ssl_verify_ca" {
  attrs = {
    endpoint_id   = "pass-verify-ca"
    endpoint_type = "target"
    engine_name   = "postgres"
    ssl_mode      = "verify-ca"
  }
}

# PASS: ssl_mode = "verify-full"
resource "aws_dms_endpoint" "pass_ssl_verify_full" {
  attrs = {
    endpoint_id   = "pass-verify-full"
    endpoint_type = "source"
    engine_name   = "oracle"
    ssl_mode      = "verify-full"
  }
}

# PASS: source endpoint with ssl_mode = "require"
resource "aws_dms_endpoint" "pass_source_endpoint_ssl" {
  attrs = {
    endpoint_id   = "pass-source-ssl"
    endpoint_type = "source"
    engine_name   = "mysql"
    ssl_mode      = "require"
  }
}

# PASS: target endpoint with ssl_mode = "verify-full"
resource "aws_dms_endpoint" "pass_target_endpoint_ssl" {
  attrs = {
    endpoint_id   = "pass-target-ssl"
    endpoint_type = "target"
    engine_name   = "redshift"
    ssl_mode      = "verify-full"
  }
}

# FAIL: ssl_mode = "none"
resource "aws_dms_endpoint" "fail_ssl_none" {
  expect_failure = true
  attrs = {
    endpoint_id   = "fail-none"
    endpoint_type = "source"
    engine_name   = "mysql"
    ssl_mode      = "none"
  }
}

# FAIL: ssl_mode = null
resource "aws_dms_endpoint" "fail_ssl_null" {
  expect_failure = true
  attrs = {
    endpoint_id   = "fail-null"
    endpoint_type = "source"
    engine_name   = "mysql"
    ssl_mode      = null
  }
}

# FAIL: ssl_mode omitted
resource "aws_dms_endpoint" "fail_ssl_missing" {
  expect_failure = true
  attrs = {
    endpoint_id   = "fail-missing"
    endpoint_type = "target"
    engine_name   = "postgres"
  }
}

# FAIL: ssl_mode = ""
resource "aws_dms_endpoint" "fail_ssl_empty_string" {
  expect_failure = true
  attrs = {
    endpoint_id   = "fail-empty"
    endpoint_type = "source"
    engine_name   = "mysql"
    ssl_mode      = ""
  }
}

# FAIL: ssl_mode = "ssl-enabled" (invalid value)
resource "aws_dms_endpoint" "fail_ssl_invalid_value" {
  expect_failure = true
  attrs = {
    endpoint_id   = "fail-invalid"
    endpoint_type = "source"
    engine_name   = "sqlserver"
    ssl_mode      = "ssl-enabled"
  }
}
