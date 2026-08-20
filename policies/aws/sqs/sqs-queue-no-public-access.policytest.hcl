# Copyright IBM Corp. 2026

policytest {
  targets = [
    "sqs-queue-no-public-access.policy.hcl"
  ]
}

# Test 1: PASS - SQS queue policy with specific AWS account principal
resource "aws_sqs_queue_policy" "pass_specific_account_principal" {
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"arn:aws:iam::123456789012:root\"},\"Action\":\"sqs:*\",\"Resource\":\"*\"}]}"
  }
}

# Test 2: FAIL - SQS queue policy with wildcard (*) as Principal string
resource "aws_sqs_queue_policy" "fail_wildcard_principal" {
  expect_failure = true
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"sqs:SendMessage\",\"Resource\":\"*\"}]}"
  }
}

# Test 3: FAIL - SQS queue policy with wildcard (*) in Principal.AWS string
resource "aws_sqs_queue_policy" "fail_wildcard_principal_aws" {
  expect_failure = true
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"*\"},\"Action\":\"sqs:ReceiveMessage\",\"Resource\":\"*\"}]}"
  }
}

# Test 4: FAIL - SQS queue with inline policy containing wildcard Principal
resource "aws_sqs_queue" "fail_inline_wildcard_principal" {
  expect_failure = true
  attrs = {
    name   = "my-public-queue"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"sqs:SendMessage\",\"Resource\":\"*\"}]}"
  }
}

# Test 5: PASS - SQS queue with inline policy restricted to specific principals
resource "aws_sqs_queue" "pass_inline_specific_principal" {
  attrs = {
    name   = "my-compliant-queue"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"arn:aws:iam::123456789012:role/MyRole\"},\"Action\":\"sqs:*\",\"Resource\":\"*\"}]}"
  }
}

# Test 6: PASS - SQS queue without policy (filtered out, not evaluated)
resource "aws_sqs_queue" "no_policy" {
  attrs = {
    name = "my-queue-no-policy"
  }
}

# Test 7: PASS - Wildcard principal but Deny effect (not public access)
resource "aws_sqs_queue_policy" "pass_wildcard_deny_effect" {
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Deny\",\"Principal\":\"*\",\"Action\":\"sqs:*\",\"Resource\":\"*\"}]}"
  }
}

# Test 8: PASS - Wildcard principal but restrictive Condition present
resource "aws_sqs_queue_policy" "pass_wildcard_with_condition" {
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"sqs:SendMessage\",\"Resource\":\"*\",\"Condition\":{\"ArnEquals\":{\"aws:SourceArn\":\"arn:aws:sns:us-east-1:123456789012:my-topic\"}}}]}"
  }
}

# Test 9: FAIL - Wildcard principal in list form: "Principal": {"AWS": ["*"]}
resource "aws_sqs_queue_policy" "fail_wildcard_aws_principal_list" {
  expect_failure = true
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":[\"*\"]},\"Action\":\"sqs:SendMessage\",\"Resource\":\"*\"}]}"
  }
}

# Test 10: FAIL - Wildcard principal in mixed list: "Principal": {"AWS": ["arn:...:root", "*"]}
resource "aws_sqs_queue_policy" "fail_wildcard_aws_principal_mixed_list" {
  expect_failure = true
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":[\"arn:aws:iam::123456789012:root\",\"*\"]},\"Action\":\"sqs:SendMessage\",\"Resource\":\"*\"}]}"
  }
}

# Test 11: FAIL - NotPrincipal with Effect: Allow is effectively public
resource "aws_sqs_queue_policy" "fail_not_principal_allow" {
  expect_failure = true
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"NotPrincipal\":{\"AWS\":\"arn:aws:iam::123456789012:root\"},\"Action\":\"sqs:SendMessage\",\"Resource\":\"*\"}]}"
  }
}

# Test 12: FAIL - Single-object Statement (not an array) with wildcard principal
resource "aws_sqs_queue_policy" "fail_single_object_statement_wildcard" {
  expect_failure = true
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":{\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"sqs:SendMessage\",\"Resource\":\"*\"}}"
  }
}

# Test 13: PASS - Single-object Statement (not an array) with specific principal
resource "aws_sqs_queue_policy" "pass_single_object_statement_specific" {
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"arn:aws:iam::123456789012:root\"},\"Action\":\"sqs:SendMessage\",\"Resource\":\"*\"}}"
  }
}

# Test 14: FAIL - Wildcard Service principal
resource "aws_sqs_queue_policy" "fail_wildcard_service_principal" {
  expect_failure = true
  attrs = {
    queue_url = "https://sqs.us-east-1.amazonaws.com/123456789012/my-queue"
    policy    = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"*\"},\"Action\":\"sqs:SendMessage\",\"Resource\":\"*\"}]}"
  }
}
