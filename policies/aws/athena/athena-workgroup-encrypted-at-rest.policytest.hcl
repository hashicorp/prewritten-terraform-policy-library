# Copyright IBM Corp. 2026

policytest {
  targets = ["athena-workgroup-encrypted-at-rest.policy.hcl"]
}

# PASS: SSE_S3 does not require a KMS key
resource "aws_athena_workgroup" "pass_sse_s3" {
  attrs = {
    name = "workgroup-sse-s3"
    configuration = [
      {
        result_configuration = [
          {
            encryption_configuration = [
              {
                encryption_option = "SSE_S3"
                kms_key_arn       = ""
              }
            ]
          }
        ]
      }
    ]
  }
}

# PASS: SSE_KMS with a non-empty kms_key_arn
resource "aws_athena_workgroup" "pass_sse_kms_with_key" {
  attrs = {
    name = "workgroup-sse-kms"
    configuration = [
      {
        result_configuration = [
          {
            encryption_configuration = [
              {
                encryption_option = "SSE_KMS"
                kms_key_arn       = "arn:aws:kms:us-east-1:123456789012:key/example-key-id"
              }
            ]
          }
        ]
      }
    ]
  }
}

# PASS: CSE_KMS with a non-empty kms_key_arn
resource "aws_athena_workgroup" "pass_cse_kms_with_key" {
  attrs = {
    name = "workgroup-cse-kms"
    configuration = [
      {
        result_configuration = [
          {
            encryption_configuration = [
              {
                encryption_option = "CSE_KMS"
                kms_key_arn       = "arn:aws:kms:us-east-1:123456789012:key/example-key-id"
              }
            ]
          }
        ]
      }
    ]
  }
}

# FAIL: SSE_KMS but kms_key_arn is empty, no managed_query_results_configuration
resource "aws_athena_workgroup" "fail_sse_kms_without_key" {
  expect_failure = true
  attrs = {
    name = "workgroup-sse-kms-no-key"
    configuration = [
      {
        result_configuration = [
          {
            encryption_configuration = [
              {
                encryption_option = "SSE_KMS"
                kms_key_arn       = ""
              }
            ]
          }
        ]
      }
    ]
  }
}

# FAIL: unrecognized encryption_option
resource "aws_athena_workgroup" "fail_invalid_encryption_option" {
  expect_failure = true
  attrs = {
    name = "workgroup-invalid-option"
    configuration = [
      {
        result_configuration = [
          {
            encryption_configuration = [
              {
                encryption_option = "NONE"
                kms_key_arn       = ""
              }
            ]
          }
        ]
      }
    ]
  }
}

# PASS: managed_query_results_configuration enabled with a non-empty kms_key, no result_configuration
resource "aws_athena_workgroup" "pass_managed_query_results_with_key" {
  attrs = {
    name = "workgroup-managed-results"
    configuration = [
      {
        managed_query_results_configuration = [
          {
            enabled = true
            encryption_configuration = [
              {
                kms_key = "arn:aws:kms:us-east-1:123456789012:key/example-key-id"
              }
            ]
          }
        ]
      }
    ]
  }
}

# FAIL: managed_query_results_configuration enabled but kms_key is empty
resource "aws_athena_workgroup" "fail_managed_query_results_without_key" {
  expect_failure = true
  attrs = {
    name = "workgroup-managed-results-no-key"
    configuration = [
      {
        managed_query_results_configuration = [
          {
            enabled = true
            encryption_configuration = [
              {
                kms_key = ""
              }
            ]
          }
        ]
      }
    ]
  }
}

# FAIL: managed_query_results_configuration present but not enabled
resource "aws_athena_workgroup" "fail_managed_query_results_disabled" {
  expect_failure = true
  attrs = {
    name = "workgroup-managed-results-disabled"
    configuration = [
      {
        managed_query_results_configuration = [
          {
            enabled = false
            encryption_configuration = [
              {
                kms_key = "arn:aws:kms:us-east-1:123456789012:key/example-key-id"
              }
            ]
          }
        ]
      }
    ]
  }
}

# FAIL: configuration block present but neither result_configuration nor managed_query_results_configuration set
resource "aws_athena_workgroup" "fail_no_encryption_paths" {
  expect_failure = true
  attrs = {
    name          = "workgroup-no-encryption"
    configuration = [
      {
        enforce_workgroup_configuration = true
      }
    ]
  }
}

# FAIL: no configuration block at all
resource "aws_athena_workgroup" "fail_no_configuration" {
  expect_failure = true
  attrs = {
    name = "workgroup-no-configuration"
  }
}

# PASS: invalid result_configuration path but valid managed_query_results_configuration path
resource "aws_athena_workgroup" "pass_either_path_valid" {
  attrs = {
    name = "workgroup-either-path"
    configuration = [
      {
        result_configuration = [
          {
            encryption_configuration = [
              {
                encryption_option = "SSE_KMS"
                kms_key_arn       = ""
              }
            ]
          }
        ]
        managed_query_results_configuration = [
          {
            enabled = true
            encryption_configuration = [
              {
                kms_key = "arn:aws:kms:us-east-1:123456789012:key/example-key-id"
              }
            ]
          }
        ]
      }
    ]
  }
}
