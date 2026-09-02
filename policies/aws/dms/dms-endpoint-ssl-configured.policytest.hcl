# Copyright IBM Corp. 2026

policytest {
  targets = ["dms-endpoint-ssl-configured.policy.hcl"]
}

resource "aws_dms_endpoint" "pass_ssl_mode_require" {
  attrs = {
    endpoint_id   = "pass-ssl-mode-require"
    endpoint_type = "source"
    engine_name   = "mysql"
    ssl_mode      = "require"
  }
}

resource "aws_dms_endpoint" "pass_ssl_mode_verify_ca" {
  attrs = {
    endpoint_id   = "pass-ssl-mode-verify-ca"
    endpoint_type = "source"
    engine_name   = "postgres"
    ssl_mode      = "verify-ca"
  }
}

resource "aws_dms_endpoint" "pass_ssl_mode_verify_full" {
  attrs = {
    endpoint_id   = "pass-ssl-mode-verify-full"
    endpoint_type = "target"
    engine_name   = "redshift"
    ssl_mode      = "verify-full"
  }
}

resource "aws_dms_endpoint" "fail_ssl_mode_none" {
  expect_failure = true
  attrs = {
    endpoint_id   = "fail-ssl-mode-none"
    endpoint_type = "source"
    engine_name   = "mysql"
    ssl_mode      = "none"
  }
}

resource "aws_dms_endpoint" "fail_ssl_mode_missing" {
  expect_failure = true
  attrs = {
    endpoint_id   = "fail-ssl-mode-missing"
    endpoint_type = "source"
    engine_name   = "mysql"
  }
}
