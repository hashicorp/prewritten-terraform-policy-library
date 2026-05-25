policytest {
  targets = [
    "ssm-automation-logging-enabled.policy.hcl"
  ]
}
<<<<<<< HEAD
// Test 1: PASS - SSM service setting with CloudWatch destination
=======
# Test 1: PASS - SSM service setting with CloudWatch destination
>>>>>>> origin/main
resource "aws_ssm_service_setting" "pass_cloudwatch_destination" {
  attrs = {
    setting_id = "arn:aws:ssm:us-east-1:123456789012:servicesetting/ssm/automation/customer-script-log-destination"
    setting_value = "CloudWatch"
  }
}

<<<<<<< HEAD
// Test 2: PASS - SSM service setting with any non-empty value (S3 also passes due to tfpolicy limitations)
=======
# Test 2: PASS - SSM service setting with any non-empty value (S3 also passes due to tfpolicy limitations)
>>>>>>> origin/main
resource "aws_ssm_service_setting" "pass_any_destination" {
  attrs = {
    setting_id = "arn:aws:ssm:us-east-1:123456789012:servicesetting/ssm/automation/customer-script-log-destination"
    setting_value = "S3"
  }
}

<<<<<<< HEAD
// Test 3: FAIL - SSM service setting with empty destination value
=======
# Test 3: FAIL - SSM service setting with empty destination value
>>>>>>> origin/main
resource "aws_ssm_service_setting" "fail_empty_destination" {
  expect_failure = true
  attrs = {
    setting_id = "arn:aws:ssm:us-east-1:123456789012:servicesetting/ssm/automation/customer-script-log-destination"
    setting_value = ""
  }
}

<<<<<<< HEAD
// Test 4: PASS - SSM service setting with valid log group name
=======
# Test 4: PASS - SSM service setting with valid log group name
>>>>>>> origin/main
resource "aws_ssm_service_setting" "pass_log_group_name_configured" {
  attrs = {
    setting_id = "arn:aws:ssm:us-east-1:123456789012:servicesetting/ssm/automation/customer-script-log-group-name"
    setting_value = "/aws/ssm/automation/executeScript"
  }
}

<<<<<<< HEAD
// Test 5: FAIL - SSM service setting with empty log group name
=======
# Test 5: FAIL - SSM service setting with empty log group name
>>>>>>> origin/main
resource "aws_ssm_service_setting" "fail_empty_log_group_name" {
  expect_failure = true
  attrs = {
    setting_id = "arn:aws:ssm:us-east-1:123456789012:servicesetting/ssm/automation/customer-script-log-group-name"
    setting_value = ""
  }
}

<<<<<<< HEAD
// Test 6: PASS - CloudWatch log group with valid name (no encryption requirement)
=======
# Test 6: PASS - CloudWatch log group with valid name (no encryption requirement)
>>>>>>> origin/main
resource "aws_cloudwatch_log_group" "pass_log_group_with_name" {
  attrs = {
    name = "/aws/ssm/automation/executeScript"
    retention_in_days = 7
  }
}

<<<<<<< HEAD
// Test 7: FAIL - CloudWatch log group with empty name
=======
# Test 7: FAIL - CloudWatch log group with empty name
>>>>>>> origin/main
resource "aws_cloudwatch_log_group" "fail_log_group_empty_name" {
  expect_failure = true
  attrs = {
    name = ""
  }
}

<<<<<<< HEAD
// Test 8: PASS - CloudWatch log group with encryption
=======
# Test 8: PASS - CloudWatch log group with encryption
>>>>>>> origin/main
resource "aws_cloudwatch_log_group" "pass_log_group_with_encryption" {
  attrs = {
    name = "/aws/ssm/automation/executeScript"
    kms_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
    retention_in_days = 7
  }
}
