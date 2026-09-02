# Copyright IBM Corp. 2026

policytest {
  targets = [
    "msk-connect-connector-logging-enabled.policy.hcl"
  ]
}

# Test 1: PASS - CloudWatch Logs enabled with a log group
resource "aws_mskconnect_connector" "pass_cloudwatch_logging" {
  attrs = {
    name = "connector-cloudwatch"
    log_delivery = [
      {
        worker_log_delivery = [
          {
            cloudwatch_logs = [
              {
                enabled   = true
                log_group = "/aws/mskconnect/connector-cloudwatch"
              }
            ]
            firehose = [
              {
                enabled         = false
                delivery_stream = ""
              }
            ]
            s3 = [
              {
                enabled = false
                bucket  = ""
              }
            ]
          }
        ]
      }
    ]
  }
}

# Test 2: PASS - Firehose enabled with a delivery stream
resource "aws_mskconnect_connector" "pass_firehose_logging" {
  attrs = {
    name = "connector-firehose"
    log_delivery = [
      {
        worker_log_delivery = [
          {
            cloudwatch_logs = [
              {
                enabled   = false
                log_group = ""
              }
            ]
            firehose = [
              {
                enabled         = true
                delivery_stream = "msk-connect-firehose-stream"
              }
            ]
            s3 = [
              {
                enabled = false
                bucket  = ""
              }
            ]
          }
        ]
      }
    ]
  }
}

# Test 3: PASS - S3 enabled with a bucket
resource "aws_mskconnect_connector" "pass_s3_logging" {
  attrs = {
    name = "connector-s3"
    log_delivery = [
      {
        worker_log_delivery = [
          {
            cloudwatch_logs = [
              {
                enabled   = false
                log_group = ""
              }
            ]
            firehose = [
              {
                enabled         = false
                delivery_stream = ""
              }
            ]
            s3 = [
              {
                enabled = true
                bucket  = "msk-connect-logs-bucket"
              }
            ]
          }
        ]
      }
    ]
  }
}

# Test 4: PASS - All three logging destinations enabled
resource "aws_mskconnect_connector" "pass_all_logging_enabled" {
  attrs = {
    name = "connector-all-logging"
    log_delivery = [
      {
        worker_log_delivery = [
          {
            cloudwatch_logs = [
              {
                enabled   = true
                log_group = "/aws/mskconnect/all-logging"
              }
            ]
            firehose = [
              {
                enabled         = true
                delivery_stream = "msk-connect-firehose-stream"
              }
            ]
            s3 = [
              {
                enabled = true
                bucket  = "msk-connect-logs-bucket"
              }
            ]
          }
        ]
      }
    ]
  }
}

# Test 5: FAIL - CloudWatch enabled but log_group is empty
resource "aws_mskconnect_connector" "fail_cloudwatch_no_log_group" {
  expect_failure = true
  attrs = {
    name = "connector-cw-no-group"
    log_delivery = [
      {
        worker_log_delivery = [
          {
            cloudwatch_logs = [
              {
                enabled   = true
                log_group = ""
              }
            ]
            firehose = [
              {
                enabled         = false
                delivery_stream = ""
              }
            ]
            s3 = [
              {
                enabled = false
                bucket  = ""
              }
            ]
          }
        ]
      }
    ]
  }
}

# Test 6: FAIL - Firehose enabled but delivery_stream is empty
resource "aws_mskconnect_connector" "fail_firehose_no_stream" {
  expect_failure = true
  attrs = {
    name = "connector-firehose-no-stream"
    log_delivery = [
      {
        worker_log_delivery = [
          {
            cloudwatch_logs = [
              {
                enabled   = false
                log_group = ""
              }
            ]
            firehose = [
              {
                enabled         = true
                delivery_stream = ""
              }
            ]
            s3 = [
              {
                enabled = false
                bucket  = ""
              }
            ]
          }
        ]
      }
    ]
  }
}

# Test 7: FAIL - S3 enabled but bucket is empty
resource "aws_mskconnect_connector" "fail_s3_no_bucket" {
  expect_failure = true
  attrs = {
    name = "connector-s3-no-bucket"
    log_delivery = [
      {
        worker_log_delivery = [
          {
            cloudwatch_logs = [
              {
                enabled   = false
                log_group = ""
              }
            ]
            firehose = [
              {
                enabled         = false
                delivery_stream = ""
              }
            ]
            s3 = [
              {
                enabled = true
                bucket  = ""
              }
            ]
          }
        ]
      }
    ]
  }
}

# Test 8: FAIL - All logging destinations disabled
resource "aws_mskconnect_connector" "fail_all_logging_disabled" {
  expect_failure = true
  attrs = {
    name = "connector-no-logging"
    log_delivery = [
      {
        worker_log_delivery = [
          {
            cloudwatch_logs = [
              {
                enabled   = false
                log_group = ""
              }
            ]
            firehose = [
              {
                enabled         = false
                delivery_stream = ""
              }
            ]
            s3 = [
              {
                enabled = false
                bucket  = ""
              }
            ]
          }
        ]
      }
    ]
  }
}

# Test 9: FAIL - No log_delivery configured (null resolves all destinations to disabled)
resource "aws_mskconnect_connector" "fail_no_log_delivery" {
  expect_failure = true
  attrs = {
    name         = "connector-no-log-delivery"
    log_delivery = null
  }
}
