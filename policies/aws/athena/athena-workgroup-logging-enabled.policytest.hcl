# Copyright IBM Corp. 2026

policytest {
  targets = [
    "athena-workgroup-logging-enabled.policy.hcl"
  ]
}

# --------------- PASS cases ---------------

# Test 1: PASS - publish_cloudwatch_metrics_enabled = true
resource "aws_athena_workgroup" "pass_logging_enabled" {
  attrs = {
    name = "compliant-workgroup"
    configuration = [
      {
        publish_cloudwatch_metrics_enabled = true
      }
    ]
  }
}

# Test 2: PASS - publish_cloudwatch_metrics_enabled = true alongside other config
resource "aws_athena_workgroup" "pass_logging_enabled_with_result_config" {
  attrs = {
    name = "compliant-workgroup-with-s3"
    configuration = [
      {
        publish_cloudwatch_metrics_enabled = true
        result_configuration = [
          {
            output_location = "s3://my-athena-results/query-results/"
          }
        ]
      }
    ]
  }
}

# --------------- FAIL cases ---------------

# Test 3: FAIL - publish_cloudwatch_metrics_enabled = false
resource "aws_athena_workgroup" "fail_logging_disabled" {
  expect_failure = true
  attrs = {
    name = "non-compliant-disabled"
    configuration = [
      {
        publish_cloudwatch_metrics_enabled = false
      }
    ]
  }
}

# Test 4: FAIL - configuration block present but publish_cloudwatch_metrics_enabled absent (defaults false)
resource "aws_athena_workgroup" "fail_logging_absent" {
  expect_failure = true
  attrs = {
    name = "non-compliant-absent-flag"
    configuration = [
      {}
    ]
  }
}

# Test 5: FAIL - no configuration block at all
resource "aws_athena_workgroup" "fail_no_configuration" {
  expect_failure = true
  attrs = {
    name = "non-compliant-no-config"
  }
}

# Test 6: FAIL - only result_configuration set, no publish_cloudwatch_metrics_enabled
resource "aws_athena_workgroup" "fail_s3_only_not_sufficient" {
  expect_failure = true
  attrs = {
    name = "non-compliant-s3-only"
    configuration = [
      {
        result_configuration = [
          {
            output_location = "s3://my-athena-results/query-results/"
          }
        ]
      }
    ]
  }
}
